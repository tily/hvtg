require('./client.css')
$ = require('jquery')
React = require('react/addons')
Button = require('react-bootstrap').Button
Input = require('react-bootstrap').Input
window.html2canvas = html2canvas = require('html2canvas')

App = React.createClass
  mixins: [React.addons.LinkedStateMixin]

  getDefaultProps: ()->
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
      '2208x1182', '1294x750', '1096x640', '920x640', '460x320'
    ]

  getInitialState: ()->
    scale: '920x640'
    title: 'S.L.A.C.K.'
    fontSize: '180px'
    fontWeight: 'bold'
    fontColor: 'white'
    backgroundSize: '100% 100%'
    imageUrl: 'https://farm4.staticflickr.com/3460/3754201159_669b929e6c_o.jpg'
    showingResult: false
    lineHeight: '1.0em'
    fontFamily: 'Pacifico'
    customFont: true
    fontCssUrl: 'http://fonts.googleapis.com/css?family=Pacifico'

  handleClickConvert: (event)->
    console.log '[app] handleClickConvert, state=', @state
    html2canvas(React.findDOMNode(@refs.preview), logging: true).then (canvas)=>
      @setState showingResult: true, ()=>
        $(React.findDOMNode(@refs.result)).html(canvas)
        $(React.findDOMNode(@refs.download)).attr
          href: canvas.toDataURL()
          download: 'apple-touch-startup-image-' + @state.scale + '.png'

  handleChange: (stateKey)->
    (newValue)=>
      newState = {showingResult: false}
      newState[stateKey] = newValue
      console.log '[app] handleChange, setting state: ', newState
      @setState newState

  valueLink: (stateKey)->
    value: @state[stateKey]
    requestChange: @handleChange(stateKey)

  render: ()->
    $('head link').attr(href: @state.fontCssUrl)

    <div className='container'>
      <div className='row'>
        <div className='col-sm-2'>
          <p style={backgroundColor: 'yellow', marginTop: '20px', marginBottom: '10px', fontWeight: 'bold'}>
            H V T G
          </p>
          <form>
            <Input type='file' label='File' placeholder='Pick a image ...' valueLink={@valueLink('file')} />
            <Input type='textarea' label='Title' placeholder='Title ...' valueLink={@valueLink('title')} />
            <Input type='text' label='Font Size' placeholder='Font Size ...' valueLink={@valueLink('fontSize')} />
            <Input type='text' label='Font Color' placeholder='Font Color ...' valueLink={@valueLink('fontColor')} />
            <Input type='text' label='Line Height' placeholder='Line Height...' valueLink={@valueLink('lineHeight')} />
            <Input type='select' label='Font Weight' placeholder='Background Size ...' valueLink={@valueLink('fontWeight')}>
              {
                @props.fontWeights.map (fontWeight)=>
                  <option key={fontWeight} value={fontWeight}>{fontWeight}</option>
              }
            </Input>
            <Input type="checkbox" label='Custom Font' checkedLink={this.linkState('customFont')} /> 
            {
              if @state.customFont
                <Input type='text' label='Font Family' placeholder='Font Family ...' valueLink={@valueLink('fontFamily')} />
              else
                <Input type='select' label='Font Family' placeholder='Font Family ...' valueLink={@valueLink('fontFamily')}>
                  {
                    @props.fontFamilies.map (fontFamily)=>
                      <option key={fontFamily} value={fontFamily}>{fontFamily}</option>
                  }
                </Input>
            }
            <Input type='select' label='Font Style' placeholder='Font Style ...' valueLink={@valueLink('fontStyle')}>
              {
                @props.fontStyles.map (fontStyle)=>
                  <option key={fontStyle} value={fontStyle}>{fontStyle}</option>
              }
            </Input>
            <Input type='text' label='Font CSS URL' placeholder='Font CSS URL ...' valueLink={@valueLink('fontCssUrl')} />
            <hr />
            <Input type='text' label='Image URL' placeholder='Image URL ...' valueLink={@valueLink('imageUrl')} />
            <Input type='select' label='Scale' valueLink={@valueLink('scale')}>
              {
                @props.scales.map (scale)=>
                  <option key={scale} value={scale}>{scale.split('x')[0]} &times; {scale.split('x')[1]}</option>
              }
            </Input>
            <Input type='select' label='Background Size' placeholder='Background Size ...' valueLink={@valueLink('backgoundSize')}>
              {
                @props.backgroundSizes.map (backgroundSize)=>
                  <option key={backgroundSize} value={backgroundSize}>{backgroundSize}</option>
              }
            </Input>
          </form>
        </div>
        <div className='col-sm-10'>
          <p style={marginTop: '20px', marginBottom: '10px'}>
            <Button onClick={@handleClickConvert} disabled={@state.showingResult}>
              Convert to Image
            </Button>
            &nbsp;
            {
              if @state.showingResult
                <span>This is Image (<a ref="download">download</a>)</span>
              else
                <span>This is <strong>NOT</strong> Image</span>
            }
          </p>
          <div ref='preview' style={
            display: if @state.showingResult then 'none' else 'flex'
            justifyContent: 'center'
            alignItems: 'center'
            textAlign: 'center'
            lineHeight: @state.lineHeight
            width: @state.scale.split('x')[0]
            height: @state.scale.split('x')[1]
            backgroundImage: 'url("/image.png?url=' + encodeURIComponent(@state.imageUrl) + '")'
            backgroundSize: @state.backgroundSize
            color: @state.fontColor
            fontFamily: @state.fontFamily
            fontSize: @state.fontSize
            fontWeight: @state.fontWeight
            fontStyle: @state.fontStyle
          }>
            <div dangerouslySetInnerHTML={ __html: @state.title.replace /\n/g, ()-> "<br />"}
            />
          </div>
        </div>
      </div>
      <div className="row">
        <div className="col-sm-12">
          <div ref='result' style={display: if @state.showingResult then 'block' else 'none'}></div>
        </div>
      </div>
    </div>

$(document).ready ()->
  app = React.createFactory(App)
  React.render app(), document.getElementById('client')
