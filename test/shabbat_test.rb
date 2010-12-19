require 'test/unit'
require 'shabbos'
require 'fakeweb'
  
class ShabbosTest < Test::Unit::TestCase
  FakeWeb.register_uri(:get, 'http://www.hebcal.com/shabbat/?geo=zip;zip=90210;m=72;cfg=r', :body => "#<HTTParty::Response:0x101cdd208 @parsed_response={'rss'=>{'version'=>'2.0', 'channel'=>{'title'=>'1-Click Shabbat: Beverly Hills, CA 90210', 'language'=>'en-us', 'copyright'=>'Copyright (c) 2010 Michael J. Radwin. All rights reserved.', 'link'=>'http://www.hebcal.com/shabbat/?geo=zip;zip=90210;m=72', 'description'=>'Weekly Shabbat candle lighting times for Beverly Hills, CA 90210', 'lastBuildDate'=>'Fri, 17 Dec 2010 08:07:38 GMT', 'item'=>[{'category'=>'holiday', 'title'=>'Asara B'Tevet', 'pubDate'=>'Fri, 17 Dec 2010 00:00:00 -0800', 'link'=>'http://www.hebcal.com/holidays/asara-btevet.html?tag=rss', 'description'=>'Friday, 17 December 2010'}, {'category'=>'candles', 'title'=>'Candle lighting: 4:28pm', 'pubDate'=>'Fri, 17 Dec 2010 16:28:00 -0800', 'link'=>'http://www.hebcal.com/shabbat/shabbat.cgi?geo=zip;zip=90210;m=72#20101217_candle_lighting', 'description'=>'Friday, 17 December 2010'}, {'category'=>'parashat', 'title'=>'Parashat Vayechi', 'pubDate'=>'Sat, 18 Dec 2010 00:00:00 -0800', 'link'=>'http://www.hebcal.com/sedrot/vayechi.html?tag=rss', 'description'=>'Saturday, 18 December 2010'}, {'category'=>'havdalah', 'title'=>'Havdalah (72 min): 5:59pm', 'pubDate'=>'Sat, 18 Dec 2010 17:59:00 -0800', 'link'=>'http://www.hebcal.com/shabbat/shabbat.cgi?geo=zip;zip=90210;m=72#20101218_havdalah_72_min', 'description'=>'Saturday, 18 December 2010'}]}, 'xmlns:geo'=>'http://www.w3.org/2003/01/geo/wgs84_pos#'}}, @response=#<Net::HTTPOK 200 OK readbody=true>, @headers={'expires'=>['Sat, 18 Dec 2010 22:38:13 GMT'], 'p3p'=>['policyref=\'http://www.hebcal.com/w3c/p3p.xml\', CP=\'ALL CURa ADMa DEVa TAIa PSAa OUR BUS IND PHY ONL COM NAV INT PRE\''], 'connection'=>['close'], 'content-type'=>['text/xml'], 'date'=>['Fri, 17 Dec 2010 22:38:13 GMT'], 'server'=>['Apache'], 'content-length'=>['1756'], 'vary'=>['Accept-Encoding']}>")

  def setup
    @shabbos = Shabbos.new("90201")
  end

  def test_find_candles_hash        
    assert @shabbos.candles[0]["category"] == "candles"
  end

  def test_find_shabbat_start
    assert @shabbos.start_time == "18:28"
  end
  
  def test_find_havdalah_hash
    assert @shabbos.havdalah[0]["category"]  == "havdalah"
  end
  
  def test_find_shabbat_end_time
    assert @shabbos.end_time == "19:58"
  end

end