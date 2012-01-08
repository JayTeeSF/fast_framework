module FastFramework
  class SampleApplication
    include FastFramework::Base

    def post
      super.tap do |page_not_found|
        page_not_found << "\nfor post: #{request_path}"
      end
    end

    def get
      page_not_found = super # in case we add any default behavior <-- may want to do an around filter ?!
      self.status = :success

      case request_path
      when url_pattern(dirs(:shock))
        ["what cho' talkin' bout willis?"]

      when url_pattern(dirs(:heartbeat_success))
        self.status = :success
        [{:status => 'OK', :message => %Q{now, 'sto...p it' --kids}}.to_json]

      when url_pattern(dirs(:heartbeat_failure))
        self.status = :error
        [{:status => 'NOK',
          :message => %Q{"You tried your best and you failed miserably. Lesson is, 'never try'." --Homer Simpson}
        }.to_json]

      when url_pattern(dirs(:four_oh_four))
        page_not_found

      when url_pattern(dirs(:info))
        [env.to_json]
      else
        self.headers = :html
        self.status = :success
        [ %Q{ <h1>Success or FAILURE?!</h1> } ].tap do |_body|
          _body << form(url(dirs(:heartbeat_success)) + ".json") do
            button('Success!')
          end
          _body << form(url(dirs(:heartbeat_failure)) + ".json") do
            button('Failure!')
          end
          _body << form(url(dirs(:info)) + ".json") do
            button('411!')
          end
          _body << form(url(dirs(:four_oh_four))) do
            button('Missing!')
          end
          _body << form(url(dirs(:shock))) do
            button('Shock!')
          end
        end

      end
    end

    private

    def dirs(url_name)
      case url_name
      when :shock
        ['arnold']

      when :heartbeat
        ['heartbeat']

      when :heartbeat_success
        dirs(:heartbeat) << lookup_status(:success)

      when :heartbeat_failure
        dirs(:heartbeat) << lookup_status(:error)

      when :four_oh_four
        ['four_oh_four']

      when :info
        ['info']
      end
    end

    def url(dirs=[],begin_str="/",join_str="/")
      begin_str + dirs.join(join_str)
    end

    def url_pattern(dirs=[],begin_str="/",join_str="/")
      Regexp.new(url(dirs,begin_str,join_str))
    end


  end
end
