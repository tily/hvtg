require('./client.css')
require('blueimp-canvas-to-blob')
$ = require('jquery')
React = require('react/addons')
Navbar = require('react-bootstrap').Navbar
Nav = require('react-bootstrap').Nav
NavItem = require('react-bootstrap').NavItem
Button = require('react-bootstrap').Button
Input = require('react-bootstrap').Input
Glyphicon = require('react-bootstrap').Glyphicon
window.html2canvas = html2canvas = require('html2canvas')
classnames = require('classnames')

window.onerror = (e, u, l)-> alert 'Error: ' + e + ' Script: ' + u + ' Line: ' + l

App = React.createClass
  mixins: [React.addons.LinkedStateMixin]

  componentDidMount: ->
    @forceUpdate()

  getDefaultProps: ()->
    sources: ['file', 'url']
    fontFamilies: [
      '', 'ヒラギノ明朝 ProN W6', 'HiraMinProN-W6', 'HG明朝E', 'ＭＳ Ｐ明朝', 'MS PMincho', 'MS 明朝', 'serif'
      'メイリオ', 'Meiryo', 'ヒラギノ角ゴ ProN W3', 'Hiragino Kaku Gothic ProN', 'ＭＳ Ｐゴシック', 'MS P Gothic'
    ]
    backgroundSizes: ['cover', 'contain', '100% 100%', 'auto 100%', '100% auto']
    fontWeights: [
      'normal', 'bold', 'lighter', 'bolder',
      100, 200, 300, 400, 500, 600, 700, 800, 900
    ]
    fontStyles: ['normal', 'italic', 'oblique']
    scales: [
      '1536x2008', '1496x2048', '768x1004', '748x1024', '1242x2148'
      '1182x2208', '750x1294', '640x1096', '640x920', '320x460'
      '2008x1536', '2048x1496', '1004x768', '1024x748', '2148x1242'
      '2208x1182', '1294x750', '1096x640', '920x640', '460x320',
      '57x57', '72x72', '76x76', '114x114', '120x120', '144x144', '152x152'
    ]

  getInitialState: ()->
    source: 'url'
    customScale: false
    originalScale: false
    scale: '920x640'
    title: 'S.L.A.C.K.'
    fontSize: '25'
    fontWeight: 'bold'
    fontColor: 'white'
    backgroundSize: '100% 100%'
    backgroundColor: 'black'
    imageUrl: 'https://farm4.staticflickr.com/3460/3754201159_669b929e6c_o.jpg'
    dataUrl: 'none'
    lineHeight: '1.0em'
    fontFamily: ''
    customFont: false
    fontCssUrl: 'http://fonts.googleapis.com/css?family=Pacifico'
    textShadow: ''
    converted: false
    result: null

  handleFile: (event)->
    reader = new FileReader
    file = event.target.files[0]
    reader.onload = (upload)=> @setState dataUrl: upload.target.result
    reader.readAsDataURL(file)
    @setState converted: false

  handleChange: (stateKey)->
    (newValue)=>
      newState = {converted: false}
      newState[stateKey] = newValue
      @setState newState

  convert: ()->
    node = React.findDOMNode(@refs.preview).cloneNode(true)
    $(node).css
      transform: 'scale(1)'
      '-webkit-transform': 'scale(1)'
      left: -99999
    $(document.body).append(node)
    html2canvas(node, logging: true).then (canvas)=>
      $(node).remove()
      console.log 'converted!,', canvas
      console.log 'converted!,', window
      console.log 'converted!,', window.dataURLtoBlob(canvas.toDataURL())
      @setState converted: true, result: canvas

  valueLink: (stateKey)->
    value: @state[stateKey]
    requestChange: @handleChange(stateKey)

  imageUrl: ()->
    if @state.source == 'file'
      @state.dataUrl 
    else
      '/image.png?url=' + encodeURIComponent(@state.imageUrl)

  imageScale: ()->
    if @state.originalScale
      width: React.findDOMNode(@refs.original).naturalWidth
      height: React.findDOMNode(@refs.original).naturalHeight
    else
      width: @state.scale.split('x')[0]
      height: @state.scale.split('x')[1]

  inputClassNames: ()->
    labelClassName: 'col-xs-6 col-sm-6'
    wrapperClassName: 'col-xs-6 col-sm-6'

  render: ()->
    imageScale = @imageScale()

    target = $(React.findDOMNode(@refs.rightColumn)).width()
    source = parseInt(imageScale.width)
    if target
      scale = target / source
    console.log 'target,source,scale', target, source, scale

    $('head link').attr(href: @state.fontCssUrl)

    <div>
      <Navbar fixedTop style={backgroundColor: 'yellow',border:0,paddingBottom:0,minHeight:0}>
        <div className='container' style={paddingTop:'10px',paddingBottom:'10px'}>
          <a href="#">H V T G</a>
          <span className="pull-right visible-xs">
            <a href="#preview"><Glyphicon glyph='picture' /></a>
            &nbsp; &nbsp; &nbsp; &nbsp;
            <a href="#title"><Glyphicon glyph='text-color' /></a>
            &nbsp; &nbsp; &nbsp; &nbsp;
            <a href="#background"><Glyphicon glyph='text-background' /></a>
          </span>
        </div>
      </Navbar>
      <div className='container'>
        <div className="row" style={height:'100%'}>
          <div ref="rightColumn" className="col-sm-4" id="preview" style={paddingTop:'50px'}>
            <p><strong>Preview</strong></p>
            <hr style={marginTop: '0px'} />
            <form style={paddingBottom:'10px'}>
              <a className='btn btn-default' onClick={@convert} disabled={@state.converted}>Convert</a>
              &nbsp;
              <a
                className='btn btn-default'
                href={if @state.result then URL.createObjectURL(window.dataURLtoBlob(@state.result.toDataURL())) else '#'}
                disabled={!@state.converted}
                download={'apple-touch-startup-image-' + @state.scale + '.png'}
                target='_blank'
              >
                <Glyphicon glyph='download-alt' />
              </a>
            </form>
            <div
              ref='preview'
              className={classnames('hvtg-display-flex': true)}
              style={
                justifyContent: 'center'
                alignItems: 'center'
                WebkitJustifyContent: 'center'
                WebkitAlignItems: 'center'
                textAlign: 'center'
                lineHeight: @state.lineHeight
                width: imageScale.width
                height: imageScale.height
                backgroundImage: 'url(' + @imageUrl() + ')'
                backgroundSize: @state.backgroundSize
                backgroundColor: @state.backgroundColor
                color: @state.fontColor
                fontFamily: @state.fontFamily
                fontSize: @state.fontSize + 'vh'
                fontWeight: @state.fontWeight
                fontStyle: @state.fontStyle
                transform: 'scale(' + (scale || 1) + ')'
                WebkitTransform: 'scale(' + (scale || 1) + ')'
                transformOrigin: '0 0 0'
                WebkitTransformOrigin: '0 0 0'
                textShadow: @state.textShadow
              }
            >
              <div dangerouslySetInnerHTML={ __html: @state.title.replace /\n/g, ()-> "<br />"} />
            </div>
          </div>
          <div className='col-sm-4' id="title" style={paddingTop:'50px'}>
            <p><strong>Title Settings</strong></p>
            <hr style={marginTop: '0px'} />
            <form className='form-horizontal'>
              <Input {...@inputClassNames()} type='textarea' label='Title' placeholder='Title ...' valueLink={@valueLink('title')} />
              <Input {...@inputClassNames()} type='number' min=1 max=100 label='Font Size' placeholder='Font Size ...' valueLink={@valueLink('fontSize')} />
              <Input {...@inputClassNames()} type='text' label='Font Color' placeholder='Font Color ...' valueLink={@valueLink('fontColor')} />
              <Input {...@inputClassNames()} type='text' label='Line Height' placeholder='Line Height...' valueLink={@valueLink('lineHeight')} />
              <Input {...@inputClassNames()} type='select' label='Font Weight' placeholder='Background Size ...' valueLink={@valueLink('fontWeight')}>
                {
                  @props.fontWeights.map (fontWeight)=>
                    <option key={fontWeight} value={fontWeight}>{fontWeight}</option>
                }
              </Input>
              {
                if @state.customFont
                  <Input {...@inputClassNames()} type='text' label='Font Family' placeholder='Font Family ...' valueLink={@valueLink('fontFamily')} />
                else
                  <Input {...@inputClassNames()} type='select' label='Font Family' placeholder='Font Family ...' valueLink={@valueLink('fontFamily')}>
                    {
                      @props.fontFamilies.map (fontFamily)=>
                        <option key={fontFamily} value={fontFamily}>{fontFamily}</option>
                    }
                  </Input>
              }
              <Input wrapperClassName='col-xs-offset-6 col-xs-6 col-sm-offset-6 col-sm-6' type="checkbox" checkedLink={this.linkState('customFont')}> 
                Custom Font
              </Input>
              <Input {...@inputClassNames()} type='select' label='Font Style' placeholder='Font Style ...' valueLink={@valueLink('fontStyle')}>
                {
                  @props.fontStyles.map (fontStyle)=>
                    <option key={fontStyle} value={fontStyle}>{fontStyle}</option>
                }
              </Input>
              <Input {...@inputClassNames()} type='text' label='Font CSS URL' placeholder='Font CSS URL ...' valueLink={@valueLink('fontCssUrl')} />
              <Input {...@inputClassNames()} type='text' label='Text Shadow' placeholder='Text Shadow ...' valueLink={@valueLink('textShadow')} />
            </form>
          </div>
          <div className='col-sm-4' id="background" style={paddingTop:'50px'}>
            <p><strong>Background Settings</strong></p>
            <hr style={marginTop: '0px'} />
            <form className='form-horizontal'>
              <Input {...@inputClassNames()} type='select' label='Source' placeholder='Source ...' valueLink={@valueLink('source')}>
                {
                  @props.sources.map (source)=>
                    <option key={source} value={source}>{source}</option>
                }
              </Input>
              {
                 if @state.source == 'file' 
                   <div className='form-group'>
                     <label className={@inputClassNames().labelClassName}>File</label>
                     <input className={@inputClassNames().wrapperClassName} type='file' onChange={@handleFile} />
                   </div>
                 else
                   <Input {...@inputClassNames()} type='text' label='Image URL' placeholder='Image URL ...' valueLink={@valueLink('imageUrl')} />
              }
              {
                if @state.customScale
                  <Input {...@inputClassNames()} type='text' label='Scale' placeholder='Scale ...' valueLink={@valueLink('scale')} />
                else
                  <Input {...@inputClassNames()} type='select' label='Scale' valueLink={@valueLink('scale')}>
                    {
                      @props.scales.map (scale)=>
                        <option key={scale} value={scale}>{scale.split('x')[0]} &times; {scale.split('x')[1]}</option>
                    }
                  </Input>
              }
              <Input wrapperClassName='col-xs-offset-6 col-xs-6 col-sm-offset-6 col-sm-6' type="checkbox" checkedLink={this.linkState('customScale')}> 
                Custom Scale
              </Input>
              <Input wrapperClassName='col-xs-offset-6 col-xs-6 col-sm-offset-6 col-sm-6' type="checkbox" checkedLink={this.linkState('originalScale')}> 
                Original Scale
              </Input>
              <Input {...@inputClassNames()} type='select' label='Background Size' placeholder='Background Size ...' valueLink={@valueLink('backgoundSize')}>
                {
                  @props.backgroundSizes.map (backgroundSize)=>
                    <option key={backgroundSize} value={backgroundSize}>{backgroundSize}</option>
                }
              </Input>
              <Input {...@inputClassNames()} type='text' label='Background Color' placeholder='Background Color ...' valueLink={@valueLink('backgroundColor')} />
            </form>
          </div>
        </div>
      </div>
      <img ref='original' src={@imageUrl()} style={display:'none'} />
    </div>

$(document).ready ()->
  app = React.createFactory(App)
  React.render app(), document.getElementById('client')
