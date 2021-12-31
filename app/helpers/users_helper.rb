module UsersHelper

  def remaining_days_notice
    days = ((current_user.created_at + 2.weeks).to_date - Date.today).round
    if days <= 2
      notice_type = 'alert'
    elsif days <= 5
      notice_type = 'warn'
    else
      notice_type = 'notice'
    end
    if days <= 0
      notice_text = "Your free trial has ended. To continue using Portholes, you can "
    elsif days == 1
      notice_text = "You have #{days} day left of your free trial. You can "
    else
      notice_text = "You have #{days} days left of your free trial. You can "
    end
    billing_link = link_to "subscribe for $24 per year", billing_create_path, method: :post, remote: true
    message = notice_text + billing_link + '.'
    content_tag(:div, message.to_s.html_safe, class: "flash flash-#{notice_type}")
  end

  def have_downloads?
    Dir.glob("#{Rails.public_path}/downloads/#{current_user.hello_token}/*.azw3").any? || Dir.glob("#{Rails.public_path}/downloads/#{current_user.hello_token}/*.mobi").any? || Dir.glob("#{Rails.public_path}/downloads/#{current_user.hello_token}/*.epub").any?
  end

  def ebook_file_name
    if have_downloads?
      array = Dir["#{Rails.public_path}/downloads/#{current_user.hello_token}/*"]
      return array[0].split('/').last
    end
  end

  def ebook_download
    array = Dir["#{Rails.public_path}/downloads/#{current_user.hello_token}/*"]
    file_path = array[0].split('/').last
    return "#{root_url}downloads/#{current_user.hello_token}/#{file_path}"
  end

end
