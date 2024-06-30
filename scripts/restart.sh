docker container stop learn-nextjs
docker container prune
docker build --build-arg SERVICE_ENV=dev -t learn-nextjs:dev . 
docker run -d --name learn-nextjs -p 3000:3000 learn-nextjs:dev
