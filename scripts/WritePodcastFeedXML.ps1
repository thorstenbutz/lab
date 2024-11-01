```powershell
[xml]$rss = New-Object System.Xml.XmlDocument
$rss.AppendChild($rss.CreateElement('rss')) | Out-Null
$rss.rss.SetAttribute('version', '2.0')
$channel = $rss.CreateElement('channel')
$rss.rss.AppendChild($channel) | Out-Null

$channel.AppendChild($rss.CreateElement('title')).InnerText = 'Podcast Title'
$channel.AppendChild($rss.CreateElement('link')).InnerText = 'http://www.example.com'
$channel.AppendChild($rss.CreateElement('description')).InnerText = 'Podcast Description'
$channel.AppendChild($rss.CreateElement('language')).InnerText = 'en-us'

$item = $rss.CreateElement('item')
$channel.AppendChild($item) | Out-Null
$item.AppendChild($rss.CreateElement('title')).InnerText = 'Episode Title'
$item.AppendChild($rss.CreateElement('link')).InnerText = 'http://www.example.com/episode'
$item.AppendChild($rss.CreateElement('description')).InnerText = 'Episode Description'
$item.AppendChild($rss.CreateElement('pubDate')).InnerText = (Get-Date).ToString('R')

$rss.OuterXml
```
