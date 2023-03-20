group "default" {
    targets = ["build-php", "php", "php-fpm"]
}

variable "CPU" {
    default = "x86"
}
variable "CPU_PREFIX" {
    default = ""
}
variable "PHP_VERSION" {
    default = "80"
}
variable "IMAGE_VERSION_SUFFIX" {
    default = "x86_64"
}
variable "DOCKER_PLATFORM" {
    default = "linux/amd64"
}

target "build-php" {
    dockerfile = "php-${PHP_VERSION}/Dockerfile"
    target     = "build-environment"
    tags       = ["bref/${CPU_PREFIX}build-php-${PHP_VERSION}"]
    args       = {
        "IMAGE_VERSION_SUFFIX" = "${IMAGE_VERSION_SUFFIX}"
    }
    platforms = ["${DOCKER_PLATFORM}"]
}

target "php" {
    dockerfile = "php-${PHP_VERSION}/Dockerfile"
    target     = "function"
    tags       = ["bref/${CPU_PREFIX}php-${PHP_VERSION}"]
    args       = {
        "IMAGE_VERSION_SUFFIX" = "${IMAGE_VERSION_SUFFIX}"
    }
    contexts = {
        "bref/${CPU_PREFIX}build-php-${PHP_VERSION}" = "target:build-php"
    }
    platforms = ["${DOCKER_PLATFORM}"]
}

target "php-fpm" {
    dockerfile = "php-${PHP_VERSION}/Dockerfile"
    target     = "fpm"
    tags       = ["bref/${CPU_PREFIX}php-${PHP_VERSION}-fpm"]
    args       = {
        "IMAGE_VERSION_SUFFIX" = "${IMAGE_VERSION_SUFFIX}"
    }
    contexts = {
        "bref/${CPU_PREFIX}build-php-${PHP_VERSION}" = "target:build-php"
        "bref/${CPU_PREFIX}php-${PHP_VERSION}"       = "target:php"
    }
    platforms = ["${DOCKER_PLATFORM}"]
}