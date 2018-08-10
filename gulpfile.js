const gulp = require('gulp')
const runSequence = require('run-sequence')
const shell = require('gulp-shell')
const watch = require('gulp-watch')

const IMAGE_NAME = 'jroberto/ejbca'
const CONTAINER_NAME = 'pki'
const VER = '1.0'

gulp.task('default', ['watch'])

gulp.task('watch', () => {
  gulp.watch(['Dockerfile','gulpfile.js','init.sh','jbossinit.sh','ejbcainit.sh','dinamo.conf' ], () => {
    runSequence(
      'stop',
      'remove',
      'build',
      'tag',
      'run',
      'key'
    )
  })
})

gulp.task('stop',
  shell.task(`docker stop ${CONTAINER_NAME}`, { ignoreErrors: true })
)

gulp.task('remove',
  shell.task(`docker rm ${CONTAINER_NAME}`, { ignoreErrors: true })
)

gulp.task('build', shell.task(`docker build -t ${IMAGE_NAME} .`, { ignoreErrors: true }))

gulp.task('tag', shell.task(`docker tag ${IMAGE_NAME} ${IMAGE_NAME}latest&&docker tag ${IMAGE_NAME} ${IMAGE_NAME}:${VER}`, { ignoreErrors: true }))

gulp.task('run',
  shell.task(`docker run -P --link banco:banco --name ${CONTAINER_NAME} ${IMAGE_NAME}`, { ignoreErrors: false })
)

gulp.task('key',
  shell.task(`docker cp ${CONTAINER_NAME}:/superadmin.p12 .`, { ignoreErrors: false })
)

gulp.task('dropdb',
  shell.task(`PGPASSWORD=serenaya00  psql -h localhost -U postgres -c 'drop database ejbca;' postgres`, { ignoreErrors: false })
)

gulp.task('initdb',
  shell.task(`PGPASSWORD=serenaya00  psql -h localhost -U postgres -c 'create database ejbca with owner ejb_user;' postgres`, { ignoreErrors: false })
)