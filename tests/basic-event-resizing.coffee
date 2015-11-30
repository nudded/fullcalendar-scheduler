
describe 'basic-view event resizing', ->
	pushOptions
		now: '2015-11-28'
		editable: true
		resources: [
			{ id: 'a', title: 'Resource A' }
			{ id: 'b', title: 'Resource B' }
		]
		views:
			basicThreeDay:
				type: 'basic'
				duration: { days: 3 }

	describe 'when there are no resource columns', ->
		pushOptions
			defaultView: 'basicWeek'
			groupByResource: false

		it 'allows non-resource resizing', (done) ->
			resizeCalled = false
			afterRenderCalled = false
			initCalendar
				events: [
					{ title: 'event1', className: 'event1', start: '2015-11-23' }
				]
				eventAfterAllRender: ->
					if afterRenderCalled
						return
					afterRenderCalled = true
					$('.event1 .fc-resizer')
						.simulate 'drag',
							endEl: getDayGridDateEls('2015-11-24').eq(0)
							callback: ->
								expect(resizeCalled).toBe(true)
								done()
				eventResize: (event) ->
					resizeCalled = true
					expect(event.start).toEqualMoment('2015-11-23')
					expect(event.end).toEqualMoment('2015-11-25')
					resource = currentCalendar.getEventResource(event)
					expect(resource).toBeFalsy()

	describe 'with resource columns above date columns', ->
		pushOptions
			defaultView: 'basicThreeDay'
			groupByResource: true

		it 'allows resizing', (done) ->
			resizeCalled = false
			afterRenderCalled = false
			initCalendar
				events: [
					{ title: 'event1', className: 'event1', start: '2015-11-29', resourceId: 'a' }
				]
				eventAfterAllRender: ->
					if afterRenderCalled
						return
					afterRenderCalled = true
					$('.event1 .fc-resizer')
						.simulate 'drag',
							endEl: getDayGridDateEls('2015-11-30').eq(0)
							callback: ->
								expect(resizeCalled).toBe(true)
								done()
				eventResize: (event) ->
					resizeCalled = true
					expect(event.start).toEqualMoment('2015-11-29')
					expect(event.end).toEqualMoment('2015-12-01')
					resource = currentCalendar.getEventResource(event)
					expect(resource.id).toBe('a')

		it 'disallows resizing across resources', (done) ->
			resizeCalled = false
			afterRenderCalled = false
			initCalendar
				events: [
					{ title: 'event1', className: 'event1', start: '2015-11-29', resourceId: 'a' }
				]
				eventAfterAllRender: ->
					if afterRenderCalled
						return
					afterRenderCalled = true
					bMonRect = getTrailingBoundingRect(getDayGridDateEls('2015-11-30'))
					$('.event1 .fc-resizer')
						.simulate 'drag',
							endPoint: getRectCenter(bMonRect)
							callback: ->
								expect(resizeCalled).toBe(false)
								done()
				eventResize: (event) ->
					resizeCalled = true

	describe 'with date columns above resource columns', ->
		pushOptions
			defaultView: 'basicThreeDay'
			groupByDateAndResource: true

		it 'allows resizing', (done) ->
			resizeCalled = false
			afterRenderCalled = false
			initCalendar
				events: [
					{ title: 'event1', className: 'event1', start: '2015-11-28', resourceId: 'b' }
				]
				eventAfterAllRender: ->
					if afterRenderCalled
						return
					afterRenderCalled = true
					bMonRect = getTrailingBoundingRect(getDayGridDateEls('2015-11-30'))
					$('.event1 .fc-resizer')
						.simulate 'drag',
							endPoint: getRectCenter(bMonRect)
							callback: ->
								expect(resizeCalled).toBe(true)
								done()
				eventResize: (event) ->
					resizeCalled = true
					expect(event.start).toEqualMoment('2015-11-28')
					expect(event.end).toEqualMoment('2015-12-01')
					resource = currentCalendar.getEventResource(event)
					expect(resource.id).toBe('b')

		it 'disallows resizing across resources', (done) ->
			resizeCalled = false
			afterRenderCalled = false
			initCalendar
				events: [
					{ title: 'event1', className: 'event1', start: '2015-11-28', resourceId: 'a' }
				]
				eventAfterAllRender: ->
					if afterRenderCalled
						return
					afterRenderCalled = true
					bMonRect = getTrailingBoundingRect(getDayGridDateEls('2015-11-30'))
					$('.event1 .fc-resizer')
						.simulate 'drag',
							endPoint: getRectCenter(bMonRect)
							callback: ->
								expect(resizeCalled).toBe(false)
								done()
				eventResize: (event) ->
					resizeCalled = true