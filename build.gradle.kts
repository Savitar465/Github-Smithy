plugins {
    `java-library`
    id("software.amazon.smithy.gradle.smithy-jar")
}

repositories {
    mavenLocal()
    mavenCentral()
    maven {
        url = uri("https://smithy-lang.jfrog.io/artifactory/smithy")
    }
}

dependencies {
    val smithyVersion: String by project

//    smithyCli("software.amazon.smithy:smithy-cli:$smithyVersion")

    // Smithy code generation plugin (note: client-codegen, NOT codegen-plugin)
    smithyBuild("software.amazon.smithy.java:client-codegen:0.0.3")

    // Runtime dependencies for the generated client
    implementation("software.amazon.smithy.java:client-core:0.0.3")
    implementation("software.amazon.smithy.java:aws-client-restjson:0.0.3")
    // Uncomment below to add various smithy dependencies (see full list of smithy dependencies in https://github.com/awslabs/smithy)
    // implementation("software.amazon.smithy:smithy-model:$smithyVersion")
    // implementation("software.amazon.smithy:smithy-linters:$smithyVersion")
}

afterEvaluate {
    val clientPath = smithy.getPluginProjectionPath(smithy.sourceProjection.get(), "java-client-codegen")
    sourceSets.main.get().java.srcDir(clientPath)
}

tasks.named("compileJava") {
    dependsOn("smithyBuild")
}

java.sourceSets["main"].java {
    srcDirs("model", "models")
}
