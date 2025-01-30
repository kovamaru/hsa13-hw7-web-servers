# hsa13-hw7-web-servers
Nginx Fine Tuning. Configure nginx that will cache only images, that were requested at least twice. Add ability to drop nginx cache by request. You should drop cache for specific file only (not all cache).

**The project consists of the following key directories and files:**

        /hsa13-hw7-web-servers
        ├── docker-compose.yml        # Docker Compose configuration file for running Nginx and Micronaut application
        ├── Dockerfile                # Dockerfile to build custom Nginx image with caching and purge module
        ├── nginx.conf                # Nginx configuration file for caching and purging
        ├── cache/                    # Directory to store cached files
        ├── micronaut-app/            # Directory for the Micronaut application
        ├── test_nginx_cache.sh       # Script to test Nginx caching behavior
        └── README.md                 # Project documentation

**Files Overview**
1. docker-compose.yml
   * This file is used to configure and run multi-container applications using Docker Compose.
   * It defines services for Nginx and the Micronaut application, making it easier to run and manage both components simultaneously.
2. Dockerfile
   * This Dockerfile is used to build a custom Nginx image that includes the necessary configuration for caching and cache purging.
   * The **reason for creating this custom Nginx Dockerfile was the need to support cache purging functionality (proxy_cache_purge)**, which was not included by default in the standard Nginx image. Therefore, we cloned and compiled the required module (ngx_cache_purge) and added it to the image.
   * For convenience and to ensure task validation, this **Dockerfile has already been built locally and pushed to Docker Hub.** This way, there is no need to rebuild the image every time, and it can be pulled directly from the registry.
3. nginx.conf
      * This is the configuration file for Nginx. It is responsible for enabling caching for the /images endpoint, managing cache validity, and handling cache purging.
      * The configuration:
         * Uses proxy_cache to cache images.
         * Sets a PURGE endpoint to allow the removal of specific cached images.
         * Configures cache expiration and conditions for stale cache use.
4. micronaut-app/
   * This directory contains the Micronaut application.
   * The application is used to serve images and simulate backend logic that the Nginx proxy communicates with. It also includes the necessary configuration to be deployed alongside Nginx in the docker-compose.yml.
5. test_nginx_cache.sh
   * This is a Bash script used to test the cache functionality of the Nginx server.
   * It runs the following tests:
     * Performs multiple requests to verify that caching works correctly (MISS on the first request and HIT on subsequent requests).
     * Triggers a PURGE request to remove the cached content.
     * Verifies that the cache is cleared and that subsequent requests after PURGE return a MISS.
     * This script automates the cache verification and ensures that everything is working as expected.

### How to Test
1. Start the Docker containers using Docker Compose:
      
        docker-compose up -d
2. Run the cache test script to verify the cache behavior:

       ./test_nginx_cache.sh
3. The script will output the results of the cache test, such as:

        🖼 Testing cache for http://localhost/images/image1
        
        🔍 First request (expecting MISS)... X-Cache-Status: MISS
        🔄 Second request (expecting MISS)... X-Cache-Status: MISS
        🔄 Third request (expecting HIT)... X-Cache-Status: HIT
        
        🧹 Purging cache for http://localhost/images/image1...
        <html><head><title>Successful purge</title></head><body bgcolor="white"><center><h1>Successful purge</h1><p>Key : localhost/images/image1</p></center></body></html>
        ✅ Success
        
        🔍 Verification after PURGE (expecting MISS)...
        X-Cache-Status: MISS
        
        🧹 Final cleanup purge for http://localhost/images/image1...
        <html><head><title>Successful purge</title></head><body bgcolor="white"><center><h1>Successful purge</h1><p>Key : localhost/images/image1</p></center></body></html>
        ✅ Success

        ✅ Test for http://localhost/images/image1 completed!
        --------------------------------------
        🖼 Testing cache for http://localhost/images/image2
        
        🔍 First request (expecting MISS)... X-Cache-Status: MISS
        🔄 Second request (expecting MISS)... X-Cache-Status: MISS
        🔄 Third request (expecting HIT)... X-Cache-Status: HIT
        
        🧹 Purging cache for http://localhost/images/image2...
        <html><head><title>Successful purge</title></head><body bgcolor="white"><center><h1>Successful purge</h1><p>Key : localhost/images/image2</p></center></body></html>
        ✅ Success
        
        🔍 Verification after PURGE (expecting MISS)...
        X-Cache-Status: MISS
        
        🧹 Final cleanup purge for http://localhost/images/image2...
        <html><head><title>Successful purge</title></head><body bgcolor="white"><center><h1>Successful purge</h1><p>Key : localhost/images/image2</p></center></body></html>
        ✅ Success

        ✅ Test for http://localhost/images/image2 completed!
        --------------------------------------
        
        ✅ All tests completed!

### Special thanks to the cats 

A huge shoutout to the cats for their exceptional help in testing the caching system, making sure everything works smoothly. And of course, for letting me use their images!

<div style="display: flex; justify-content: space-between;">
  <img src="https://raw.githubusercontent.com/kovamaru/hsa13-hw7-web-servers/main/simple-backend/src/main/resources/images/image1.jpg" alt="Test image 1" width="300" />
  <img src="https://raw.githubusercontent.com/kovamaru/hsa13-hw7-web-servers/main/simple-backend/src/main/resources/images/image2.jpg" alt="Test image 2" width="300" />
</div>
