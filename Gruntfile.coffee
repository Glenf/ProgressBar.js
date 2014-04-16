module.exports = (grunt) ->

	require('time-grunt')(grunt)	
	require('load-grunt-config')(grunt, {
		loadGruntTasks : 
			config : require('./package.json')
		})

