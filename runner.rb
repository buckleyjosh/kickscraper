class Runner
  def run
    scrape_pages(5) # Rewrite this to run until it hits a faimliar record
  end

  private

  def scrape_pages(number)
    (1..number).each do |page_number|
      puts "Starting page #{page_number}"
      kickstarter_page(page_number).css('.project-card-list li.project').each do |project|
        Project.new.tap do |p|
          p.title = project.css('.project-card h2 strong a').text
          p.amount = kickstarter_money_to_cents(project.css('.pledged strong').text[1..-1])
          p.date_funded = Date.parse(project.css('.deadline').text.strip)
          p.url = "http://kickstarter.com#{project.css('.project-card h2 strong a')[0]['href']}"
        end.save
      end
      puts "Finished page #{page_number}"
    end
  end

  def kickstarter_money_to_cents(kickstarter_money_string)
    slightly_sanitized = kickstarter_money_string.gsub("$",'').gsub(",",'')
    (slightly_sanitized.to_f * 100.0).round
  end

  def kickstarter_page(page_number)
    Nokogiri::HTML(RestClient.get("http://www.kickstarter.com/discover/successful?page=#{CGI.escape(page_number.to_s)}"))
  end
end