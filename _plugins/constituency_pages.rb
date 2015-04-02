module Jekyll

  class ConstituencyPage < Page
    def initialize(site, base, dir, constituency)
      @site = site
      @base = base
      @dir = dir

      @name = 'index.html'
      self.process(@name)
      self.read_yaml(File.join(base, '_layouts'), 'constituency.html')
      self.data['constituency'] = constituency
      self.data['title'] = "Candidates (PPCs) for #{constituency['name']} in the UK 2015 General Election"
      self.data['hero'] = "Candidates for #{constituency['name']}"

    end
  end

  # class JSONPartyIndexPage < Page
  #   def initialize(site, base, dir, party)
  #     @site = site
  #     @base = base
  #     @dir = dir
  #
  #     @name = 'index.json'
  #     self.process(@name)
  #     self.read_yaml(File.join(base), 'parties.json')
  #     self.data['party'] = party
  #
  #   end
  # end
  #
  # class JSONPartyPage < Page
  #   def initialize(site, base, dir, party)
  #     @site = site
  #     @base = base
  #     @dir = dir
  #
  #     @name = 'data.json'
  #     self.process(@name)
  #     self.read_yaml(File.join(base, '_layouts'), 'party.json')
  #     self.data['party'] = party
  #     self.data['title'] = party['party_name']
  #
  #   end
  # end

  class ConstituencyPageGenerator < Generator
    safe true

    def generate(site)
      if site.layouts.key? 'constituency'
        dir = 'constituencies/'
        site.data['mapit-WMC-generation-22'].each do |constituency|
          site.pages << ConstituencyPage.new(site, site.source, File.join(dir, constituency[0]), constituency[1])
        end
      end
    end
  end

end