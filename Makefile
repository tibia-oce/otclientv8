compile:
	docker build -t otclient:latest .
	docker create --name otclient_build otclient:latest
	docker cp otclient_build:/otclient/otclient ./otclient
	docker rm otclient_build

clean:
	docker rm -f otclient_build
	docker system prune -af --volumes
