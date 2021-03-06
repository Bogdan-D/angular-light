
alight.d.al.include =
    priority: 100
    stopBinding: true
    link: (scope, element, name, env) ->
        child = null
        baseElement = null
        topElement = null
        activeElement = null
        self =
            start: ->
                self.prepare()
                self.watchModel()
                return
            prepare: ->
                baseElement = element
                topElement = document.createComment " #{env.attrName}: #{name} "
                f$.before element, topElement
                f$.remove element
                return
            loadHtml: (cfg) ->
                f$.ajax cfg
                return
            removeBlock: ->
                if child
                    child.destroy()
                    child = null
                if activeElement
                    self.removeDom activeElement
                    activeElement = null
                return
            insertBlock: (html) ->
                activeElement = baseElement.cloneNode true
                activeElement.innerHTML = html
                self.insertDom topElement, activeElement
                child = env.changeDetector.new()
                alight.bind child, activeElement,
                    skip_attr: env.skippedAttr()
                return
            updateDom: (url) ->
                if not url
                    self.removeBlock()
                    return
                self.loadHtml
                    cache: true
                    url: url
                    success: (html) ->
                        self.removeBlock()
                        self.insertBlock html
                    error: self.removeBlock
                return
            removeDom: (element) ->
                f$.remove element
                return
            insertDom: (base, element) ->
                f$.after base, element
                return
            watchModel: ->
                scope.$watch name, self.updateDom
                return

        self
