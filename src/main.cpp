/*
 * Copyright (c) 2010-2017 OTClient <https://github.com/edubart/otclient>
 *
 * Permission is hereby granted, free of charge, to any person obtaining a copy
 * of this software and associated documentation files (the "Software"), to deal
 * in the Software without restriction, including without limitation the rights
 * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 * copies of the Software, and to permit persons to whom the Software is
 * furnished to do so, subject to the following conditions:
 *
 * The above copyright notice and this permission notice shall be included in
 * all copies or substantial portions of the Software.
 *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
 * THE SOFTWARE.
 */

#include <framework/core/application.h>
#include <framework/core/resourcemanager.h>
#include <framework/core/eventdispatcher.h>
#include <framework/luaengine/luainterface.h>
#include <framework/http/http.h>
#include <framework/platform/crashhandler.h>
#include <framework/platform/platformwindow.h>
#include <client/client.h>

int main(int argc, const char* argv[]) {
    std::vector<std::string> args(argv, argv + argc);

#ifdef CRASH_HANDLER
    installCrashHandler();
#endif

    // initialize resources
    g_resources.init(argv[0]);
    std::string compactName = g_resources.getCompactName();
    g_logger.setLogFile(compactName + ".log");

    // setup application name and version
    g_app.setName("OTClientV8");
    g_app.setCompactName(compactName);
    g_app.setVersion("3.1");

#ifdef WITH_ENCRYPTION
    if (std::find(args.begin(), args.end(), "--encrypt") != args.end()) {
        g_lua.init();
        g_resources.encrypt(args.size() >= 3 ? args[2] : "");
        std::cout << "Encryption complete" << std::endl;
#ifdef WIN32
        MessageBoxA(NULL, "Encryption complete", "Success", 0);
#endif
        return 0;
    }
#endif

    if (g_resources.launchCorrect(g_app.getName(), g_app.getCompactName())) {
        return 0; // started other executable
    }

    // initialize application framework and otclient
    g_app.init(args);
    g_client.init(args);
    g_http.init();

    bool testMode = std::find(args.begin(), args.end(), "--test") != args.end();
    if (testMode) {
        g_logger.setTestingMode();    
    }

    // find script init.lua and run it
    g_resources.setupWriteDir(g_app.getName(), g_app.getCompactName());
    g_resources.setup();

    if (!g_lua.safeRunScript("init.lua")) {
        if (g_resources.isLoadedFromArchive() && !g_resources.isLoadedFromMemory() &&
            g_resources.loadDataFromSelf(true)) {
            g_logger.error("Unable to run script init.lua! Trying to run version from memory.");
            if (!g_lua.safeRunScript("init.lua")) {
                g_resources.deleteFile("data.zip"); // remove incorrect data.zip
                g_logger.fatal("Unable to run script init.lua from binary file!\nTry to run client again.");
            }
        } else {
            g_logger.fatal("Unable to run script init.lua!");
        }
    }

    if (testMode) {
        if (!g_lua.safeRunScript("test.lua")) {
            g_logger.fatal("Can't run test.lua");
        }
    }

#ifdef WIN32
    // support for progdn proxy system, if you don't have this dll nothing will happen
    // however, it is highly recommended to use otcv8 proxy system
    LoadLibraryA("progdn32.dll");
#endif

    // the run application main loop
    g_app.run();

#ifdef CRASH_HANDLER
    uninstallCrashHandler();
#endif

    // unload modules
    g_app.deinit();

    // terminate everything and free memory
    g_http.terminate();
    g_client.terminate();
    g_app.terminate();
    return 0;
}
