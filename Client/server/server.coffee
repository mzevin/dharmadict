terms = [
	{
		id: "1"
		wylie: "chos"
		sanskrit: "дхамма, дхарма"
		wikipedia: "http://wikipedia.org/x/"
		translations: [
			{
				translator: "Маргарита Кожевникова"
				comment: "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Fusce condimentum augue vitae erat viverra ullamcorper. Sed porttitor eget odio in fermentum. Fusce est ipsum, porttitor id eros sit amet, mollis iaculis enim. In accumsan fringilla nisl, condimentum aliquet arcu blandit vitae. In felis velit, lacinia a odio ac, tincidunt interdum quam. Praesent aliquam nulla ut turpis pretium, sed imperdiet mi varius. Pellentesque nec turpis rutrum, pretium massa eu, ornare justo. Praesent et lacus est. Fusce at risus vel lacus vestibulum scelerisque. Morbi tempor mauris sit amet arcu faucibus, quis porta elit facilisis. Praesent malesuada leo sit amet elit pellentesque, ullamcorper suscipit est scelerisque."
				meanings: [
					{
						versions: [{rus: "Дхарма"},{rus: "духовное учение"},{rus: "Учение"}]
					},
					{
						versions: [{rus: "элементы бытия"},{rus: "феномены"},{rus: "явления"}]
						comment: "Все те элементы, представляющие из себя моменты сознания, на которые раскладывается психо-мир в буддийской теории (абидарма), метафизике"
					}
				]
			}
		]
	},
	{
		id: "2"
		wylie: "chos nyid"
		sanskrit: "дхармата"
		wikipedia: "http://wikipedia.org/x/"
		translations: [
			{
				translator: "Маргарита Кожевникова"
				comment: "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Fusce condimentum augue vitae erat viverra ullamcorper. Sed porttitor eget odio in fermentum. Fusce est ipsum, porttitor id eros sit amet, mollis iaculis enim. In accumsan fringilla nisl, condimentum aliquet arcu blandit vitae. In felis velit, lacinia a odio ac, tincidunt interdum quam. Praesent aliquam nulla ut turpis pretium, sed imperdiet mi varius. Pellentesque nec turpis rutrum, pretium massa eu, ornare justo. Praesent et lacus est. Fusce at risus vel lacus vestibulum scelerisque. Morbi tempor mauris sit amet arcu faucibus, quis porta elit facilisis. Praesent malesuada leo sit amet elit pellentesque, ullamcorper suscipit est scelerisque."
				meanings: [
					{
						versions: [{rus: "подлинное-бытие"}]
					}
				]
			}
		]
	},
	{
		id: "3"
		wylie: "chos mngon pa"
		sanskrit: ""
		wikipedia: "http://wikipedia.org/x/"
		translations: [
			{
				translator: "Маргарита Кожевникова"
				meanings: [
					{
						versions: [{rus: "теория элементов бытия (Абхидхарма)"}]
					}
				]
			}
		]
	},
	{
		id: "4"
		wylie: "sku gsum"
		sanskrit: "три кая"
		wikipedia: "http://wikipedia.org/x/"
		translations: [
			{
				translator: "Маргарита Кожевникова"
				comment: "Три уровня проявления Пробужденного"
				meanings: [
					{
						versions: [{rus: "три Тела Будды"}]
						comment: ""
					}
				]
			}
		]
		subTerms: [
			{
				id: "41"
				wylie: "chos (kyi) sku"
				sanskrit: "Дхармакая"
				translations: [
					{
						translator: "Маргарита Кожевникова"
						meanings: [{versions: [{rus: "Тело учения"}], comment:""}]
					}
				]
			},
			{
				id: "42"
				wylie: "longs sku"
				sanskrit: "Самбхогакая"
				translations: [
					{
						translator: "Маргарита Кожевникова"
						meanings: [{versions: [{rus: "Тело блаженства"}], comment:""}]
					}
				]
			},
			{
				id: "43"
				wylie: "sprul (pa'i) sku"
				sanskrit: "Нирманакая"
				translations: [
					{
						translator: "Маргарита Кожевникова"
						meanings: [{versions: [{rus: "Тело воплощения"}], comment:""}]
					}
				]
			}
		]
	}
]

module.exports = (app, options) ->

	app.get '/', (req, res) ->
		res.render "#{options.base}/index.html"

	app.get '/api/terms', (req, res) ->
		res.json terms
