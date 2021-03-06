
alight.d.al.checked =
    priority: 20
    link: (scope, element, name) ->
        self =
            start: ->
                self.onDom()
                self.watchModel()
                return
            onDom: ->
                f$.on element, 'change', self.updateModel
                scope.$watch '$destroy', self.offDom
                return
            offDom: ->
                f$.off element, 'change', self.updateModel
                return
            updateModel: ->
                value = element.checked
                scope.$setValue name, value
                self.watch.refresh()
                scope.$scan()
                return
            watchModel: ->
                self.watch = scope.$watch name, self.updateDom
                return
            updateDom: (value) ->
                element.checked = !!value
                '$scanNoChanges'
