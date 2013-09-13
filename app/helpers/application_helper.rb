module ApplicationHelper
  def show_flash_messages
    hash = {
      :error => 'alert alert-error',
      :alert => 'alert alert-error',
      :notice => 'alert alert-success'
    }
    
    content_tag :div do
      hash.keys.each do |flash_type|
        if flash[flash_type]
          safe_concat %{
            <div class='#{hash[flash_type]}'>
              #{flash[flash_type]}
            </div>
          }
        end
      end
    end
  end
end
