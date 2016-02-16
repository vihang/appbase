name := """app"""

version := "1.0-SNAPSHOT"

scalaVersion := "2.11.6"

resolvers ++= Seq(
"google-sedis-fix" at "http://pk11-scratch.googlecode.com/svn/trunk",
"Madoushi sbt-plugins" at "https://dl.bintray.com/madoushi/sbt-plugins/"
)

resolvers += "mandubian maven bintray" at "http://dl.bintray.com/mandubian/maven"
resolvers += "Sonatype Snapshots" at "https://oss.sonatype.org/content/repositories/snapshots/"
resolvers += "scalaz-bintray" at "http://dl.bintray.com/scalaz/releases"


libraryDependencies += "mysql" % "mysql-connector-java" % "5.1.18"

libraryDependencies += "com.amazonaws" % "aws-java-sdk" % "1.10.40"

libraryDependencies += "javax.mail" % "mail" % "1.4.1"

libraryDependencies += "javax.inject" % "javax.inject" % "1"

libraryDependencies += "org.mindrot" % "jbcrypt" % "0.3m"

libraryDependencies += "org.mockito" % "mockito-core" % "1.9.5" % "test"

libraryDependencies += "org.scalatestplus" % "play_2.11" % "1.1.1" % "test"

libraryDependencies += "com.auth0" % "java-jwt" % "2.0.0"

libraryDependencies += "commons-codec" % "commons-codec" % "1.9"

libraryDependencies += "com.typesafe.play.modules" %% "play-modules-redis" % "2.4.0"

libraryDependencies += "com.github.tototoshi" %% "scala-csv" % "1.2.1"

//added by vihang - for Searchfeature
libraryDependencies +=  "org.elasticsearch" % "elasticsearch" % "1.6.0"

//added by vihang for akka camel sqs support
libraryDependencies ++= Seq(
  "org.apache.camel" % "camel-aws" % "2.16.1",
  "com.typesafe.akka" %% "akka-actor" % "2.4.1",
  "com.typesafe.akka" %% "akka-camel" % "2.4.1"
)

 
//added by vihang to support swagger documenation for API
//libraryDependencies +=    "com.wordnik" %% "swagger-play2" % "1.3.12"

libraryDependencies ++= Seq(
  "org.reactivemongo" %% "play2-reactivemongo" % "0.11.7.play24"
)

libraryDependencies +=   "com.mandubian"     %% "play-json-zipper"    % "1.2"

libraryDependencies +=  "com.typesafe.play" %% "anorm" % "2.4.0"


libraryDependencies ++= Seq(
  jdbc,
  cache,
  ws,
  specs2 % Test,
  filters
)

resolvers += "scalaz-bintray" at "http://dl.bintray.com/scalaz/releases"

// Play provides two styles of routers, one expects its actions to be injected, the
// other, legacy style, accesses its actions statically.
routesGenerator := InjectedRoutesGenerator
EclipseKeys.preTasks := Seq(compile in Compile)
