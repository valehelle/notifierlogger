class ChangelogController < ApplicationController
    skip_before_action :verify_authenticity_token
    def webhook
        request.body.rewind
        payload_body = request.body.read
        if verify_signature(payload_body)
            json_data = JSON.parse(request.raw_post)
            action = json_data['action']
            merged = body = json_data['pull_request']['merged']
            if action == 'closed' && merged
                body = json_data['pull_request']['body']
                type = ''
                change = ''
                added = ''
                deprecated = ''
                removed = ''
                fixed = ''
                security = ''
                notify = ''
                body.each_line do |line|
                    header = false

                    strip_line = line.gsub(/\s+/, '')
                    strip_line.upcase!
                    if strip_line.to_s == "###CHANGED"
                        type = 'C'
                        header = true
                    elsif strip_line == '###ADDED'
                        type = 'A'
                        header = true
                    elsif strip_line == '###DEPRECATED'
                        type = 'D'
                        header = true
                    elsif strip_line == '###REMOVED'
                        type = 'R'
                        header = true
                    elsif strip_line == '###FIXED'
                        type = 'F'
                        header = true
                    elsif strip_line == '###SECURITY'
                        type = 'S'
                        header = true
                    elsif strip_line == '###NOTIFY'
                        type = 'N'
                        header = true
                    end
                    
                    if !header
                        if type == 'C'
                            change = change + line
                        elsif type == 'A'
                            added = added + line
                        elsif type == 'D'
                            deprecated = deprecated + line
                        elsif type == 'R'
                            removed = removed + line
                        elsif type == 'F'
                            fixed = fixed + line
                        elsif type == 'S'
                            security = security + line
                        elsif type == 'N'
                            notify = notify + line
                        end
                    end
                end
                save_changelog(change,added,deprecated,removed,fixed,security)
            end
            
            
        end
        render status: :ok
    end


    def edit
        @releaselog = current_user.releaselogs.find(params[:id])
    end

    def update
        @releaselog = current_user.releaselogs.find(params[:id])
        if @releaselog.update_attributes(log_params)
            if @releaselog.release_version != 'Unreleased' && @releaselog.is_released == false
                @releaselog.is_released = true
                @releaselog.save!
                project = @releaselog.project
                new_release = project.releaselogs.new
                new_release.release_version = 'Unreleased'
                new_release.is_released = false
                new_release.modify = ''
                new_release.added = ''
                new_release.deprecated = ''
                new_release.removed = ''
                new_release.fixed = ''
                new_release.security = ''
                new_release.user = current_user
                releaselog.save!
                #notify people

            end
            # Handle a successful update.
            redirect_to project_path(@releaselog.project)
          else
            render 'edit'
        end
    end


    private
    def log_params
    
        params.require(:releaselog).permit(:modify, :added, :fixed, :deprecated, :removed, :security, :notify, :release_version)

    end

    def save_changelog(change,added,deprecated,removed,fixed,security)
        project = Project.find_by(webhook: params[:id])
        if project.releaselogs.exists?(is_released: false)
            releaselog = project.releaselogs.find_by(is_released: false)
            releaselog.modify = releaselog.modify + change
            releaselog.added = releaselog.added + added
            releaselog.deprecated = releaselog.deprecated + deprecated
            releaselog.removed = releaselog.removed + removed
            releaselog.fixed = releaselog.fixed + fixed
            releaselog.security = releaselog.security + security
            releaselog.user = project.user
            releaselog.save!
        else
            releaselog = project.releaselogs.new
            releaselog.release_version = 'Unreleased'
            releaselog.is_released = false
            releaselog.modify = change
            releaselog.added = added
            releaselog.deprecated = deprecated
            releaselog.removed = removed
            releaselog.fixed = fixed
            releaselog.security = security
            releaselog.user = project.user
            releaselog.save!
        end

    end

    def verify_signature(payload_body)
        signature = 'sha1=' + OpenSSL::HMAC.hexdigest(OpenSSL::Digest.new('sha1'), 'secret', payload_body)
        return Rack::Utils.secure_compare(signature, request.env['HTTP_X_HUB_SIGNATURE'])
    end

end
