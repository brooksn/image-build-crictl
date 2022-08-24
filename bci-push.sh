#!/bin/sh

make DRONE_TAG="v1.20.0-build20211118" BUILD_META="-build20211118" ORG=bcibase image-push
make DRONE_TAG="v1.20.0-build20211118" BUILD_META="-build20211118" ORG=bcibase image-manifest

make DRONE_TAG="v1.21.0-build20211118" BUILD_META="-build20211118" ORG=bcibase image-push
make DRONE_TAG="v1.21.0-build20211118" BUILD_META="-build20211118" ORG=bcibase image-manifest

make DRONE_TAG="v1.23.0-build20220414" BUILD_META="-build20220414" ORG=bcibase image-push
make DRONE_TAG="v1.23.0-build20220414" BUILD_META="-build20220414" ORG=bcibase image-manifest

make DRONE_TAG="v1.24.0-build20220506" BUILD_META="-build20220506" ORG=bcibase image-push
make DRONE_TAG="v1.24.0-build20220506" BUILD_META="-build20220506" ORG=bcibase image-manifest
