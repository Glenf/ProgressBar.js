module.exports =
	dist :
		options :
			compress :
				# banner : '/* <%= package.name %> - <%= package.version %> - <%= grunt.template.today("yyyy-mm-dd") %> */\n'
				drop_console : true

		files :
			'progressbar.min.js' : 'progressbar.js' 