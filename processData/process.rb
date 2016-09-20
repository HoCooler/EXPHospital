require 'yaml'
require 'JSON'
require 'net/http'

def traverse_dir(file_path)
	if File.directory? file_path
    Dir.foreach(file_path) do |file|
      if file!="." and file!=".."
        traverse_dir(file_path+"/"+file){|x| yield x}
      end
    end
  else
    yield  file_path
  end
end

path = '.'

output_file_list_name = 'dataList.json'
output_file_array_name = 'dataArray.json'

hospital_nolocation_Array = Array.new
hospitalArray = Array.new

traverse_dir(path){ |f|
	if f.to_s =~ /\.yml$/
		data = YAML.load(File.open(f))
    if data["location"] and data["location"].is_a?(::Hash) and data["location"]["lat"] and data["location"]["lng"]
      puts f.to_s + " －－－－－－ use local"
      hospitalArray << data
    else
      #高德地图 API
     puts f.to_s + " －－－－－－ use API"

      uri = URI('http://restapi.amap.com/v3/place/text')
      params = { :key => '74aa497649a0dd035a8a3b2c2270630e', :keywords => data['name'], :type => '医院', :city => data['city'], :citylimit => 'true', :offset => '1'}
      uri.query = URI.encode_www_form(params)
      res = Net::HTTP.get_response(uri)

      if res.is_a?(Net::HTTPSuccess)
        result = YAML.load(res.body)
        location = Hash[*result["pois"]]['location'].split(',') if Hash[*result["pois"]]['location']
        data["location"] = Hash["lng" => location[0], "lat" => location[1]] if location
        unless data["address"].nil? && result["pois"]
          data["address"] = Hash[*result["pois"]]['address'] 
        end
      end
      hospitalArray << data 
    end

	end
}

hospitalList = JSON.generate({'data' => hospitalArray})

File.open(output_file_list_name, 'w') { |file| file.write(hospitalList) }
File.open(output_file_array_name, 'w') { |file| file.write(JSON.generate(hospitalArray))}




# dataversion: draft1 #数据格式版本
# created: 1462667234 #文件创建时间
# updated: 1462667234 #修改时间
# id: b68f8b16-26e4-4ab1-bce0-459e02b447ef #Version 4 UUID
# USID: "" #注册号/统一社会信用代码
# name: 北京艾丽斯妇科医院 #名称
# city: 北京 #城市
# province: 北京 #省份
# address: 北京市海淀区北四环西路9号 #地址
# type: 民营医院 #类型，民营医院/外包科室
# location:  #经纬度，目前使用地址从Google maps获得
#   - lat : 39.987327
#     lng : 116.334477
# principal: "" #负责人 可使用各省工商局提供的企业信用公示系统获得
# shareholder:  #股东 可能有多位 可使用各省工商局提供的企业信用公示系统获得
#   - ""
#   - ""
# url: #医院网站 可能有很多个
#   - http://www.fuke120.cn
# phone: #医院电话 可能有很多个
#   - 010-62800867
# baiduad: #百度广告情况
#   - confirm: No #是否投放 Yes/No/null
#   - evidence: #证据
#     - url: ""
#       title: ""
#       snapshot: ""
#       dateline: ""
#     - url: ""
#       title: ""
#       snapshot: ""
#       dateline: ""
# news:  #媒体报道 URL和快照
#   - evidence: #证据
#     - url: http://money.163.com/16/0329/09/BJAIJCRK00253B0H.html #原始URL
#       title: ""
#       snapshot: http://snapshot/http://money.163.com/16/0329/09/BJAIJCRK00253B0H.html #快照 格式可以是稳定的第三方快照服务，也可以是页面截图链接
#       dateline: san577478, OpenPower, 05/08/2016 @ 12:27am (UTC) - submit #dateline是新闻媒体常用的格式，一般是一小段文本，写明贡献者、组织、时间、描述。参考： https://en.wikipedia.org/wiki/Dateline
#     - url: ""
#       snapshot: ""
#       dateline: ""
# putian: #莆田系相关
#   - confirm: #是否确认 Yes/No/null
#   - evidence: #证据
#     - url: ""
#       title: ""
#       snapshot: ""
#       dateline: ""
#     - url: ""
#       title: ""
#       snapshot: ""
#       dateline: ""

# comments: #用户评论 URL和快照
#   - evidence: #证据
#     - url: http://www.dianping.com/shop/4674723/review_more
#       title: ""
#       snapshot: http://snapshot/http://www.dianping.com/shop/4674723/review_more
#       dateline: san577478, OpenPower, 05/08/2016 @ 12:27am (UTC) - submit
#     - url: http://ask.yaolan.com/question/15112409310913796432.html
#       title: ""
#       snapshot: http://snapshot/http://ask.yaolan.com/question/15112409310913796432.html
#       dateline: san577478, OpenPower, 05/08/2016 @ 12:27am (UTC) - submit