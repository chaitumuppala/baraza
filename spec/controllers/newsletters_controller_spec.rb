# require 'rails_helper'
#
# RSpec.describe NewslettersController, type: :controller do
#   context 'update' do
#     it 'should update and approve the newsletter if params[:commit] is PUBLISH', admin_sign_in: true do
#       create(:subscriber)
#       newsletter = create(:newsletter)
#       category = create(:category)
#       article1 = create(:article)
#       cn = CategoryNewsletter.create(newsletter: newsletter, category: category)
#       mailer = double('mailer', deliver_now: '')
#       expect(NewsletterMailer).to receive(:send_mail).with(newsletter).and_return(mailer)
#       patch :update, 'newsletter' => {
#         'category_newsletters_attributes' => [{ 'position_in_newsletter' => '100', 'category_id' => category.id, 'newsletter_id' => newsletter.id, 'id' => cn.id }
#                                              ], 'article_ids' => [article1.id],
#         'articles_attributes' => [{ 'position_in_newsletter' => '1', 'id' => article1.id }] },
#                      'commit' => NewslettersController::PUBLISH, 'id' => newsletter.id
#
#       expect(flash[:notice]).to eq('eMagazine was successfully sent out to the subscribers')
#       expect(response).to redirect_to(newsletters_path)
#       expect(CategoryNewsletter.where(newsletter: newsletter, category: category).first.position_in_newsletter).to eq(100)
#       expect(newsletter.reload.status).to eq(Newsletter::Status::PUBLISHED)
#     end
#
#     it 'should remove article params which dont have ids in article_ids', admin_sign_in: true do
#       create(:subscriber)
#       newsletter = create(:newsletter)
#       category = create(:category)
#       CategoryNewsletter.create(newsletter: newsletter, category: category)
#       article1 = create(:article)
#       article2 = create(:article)
#       article3 = create(:article)
#       newsletter.articles << [article1, article2, article3]
#
#       expect(NewsletterMailer).not_to receive(:send_mail).with(newsletter)
#
#       patch :update, 'newsletter' => { 'article_ids'         => [article1.id],
#                                        'articles_attributes' => [{ 'position_in_newsletter' => '1', 'id' => article1.id }, { 'position_in_newsletter' => '2', 'id' => article2.id }, { 'position_in_newsletter' => '3', 'id' => article3.id }] },
#                      'commit' => NewslettersController::SAVE, 'id' => newsletter.id
#
#       expect(newsletter.reload.articles).to eq([article1])
#       expect(flash[:notice]).to eq('eMagazine is saved successfully')
#       expect(response).to redirect_to(edit_newsletter_path(newsletter))
#     end
#
#     it 'should throw error if no article is selected', admin_sign_in: true do
#       create(:subscriber)
#       newsletter = create(:newsletter)
#       category = create(:category)
#       CategoryNewsletter.create(newsletter: newsletter, category: category)
#       article1 = create(:article)
#       article2 = create(:article)
#       article3 = create(:article)
#       newsletter.articles << [article1, article2, article3]
#
#       patch :update, 'newsletter' => { 'articles_attributes' => [{ 'position_in_newsletter' => '1', 'id' => article1.id }, { 'position_in_newsletter' => '2', 'id' => article2.id }, { 'position_in_newsletter' => '3', 'id' => article3.id }] },
#                      'commit' => NewslettersController::SAVE, 'id' => newsletter.id
#
#       expect(flash[:alert]).to eq('Select at least one article')
#       expect(response).to render_template('edit')
#     end
#
#     it 'should throw error if no subscribers', admin_sign_in: true do
#       newsletter = create(:newsletter)
#       category = create(:category)
#       CategoryNewsletter.create(newsletter: newsletter, category: category)
#       article1 = create(:article)
#       newsletter.articles << [article1]
#
#       patch :update, 'newsletter' => { 'articles_attributes' => [{ 'position_in_newsletter' => '1', 'id' => article1.id }] },
#                      'commit' => NewslettersController::SAVE, 'id' => newsletter.id
#
#       expect(flash[:alert]).to eq('There are no subscribers')
#       expect(response).to render_template('edit')
#     end
#   end
#
#   context 'new' do
#     it 'should new only if there are no draft newsletters', admin_sign_in: true do
#       Newsletter.where(status: Newsletter::Status::DRAFT).destroy_all
#       n = create(:newsletter, status: Newsletter::Status::DRAFT)
#       n.update_attributes(status: Newsletter::Status::PUBLISHED)
#
#       create(:newsletter, status: Newsletter::Status::DRAFT)
#
#       get :new
#       expect(response).to redirect_to(root_path)
#     end
#
#     it 'should new only if there are no draft newsletters', admin_sign_in: true do
#       create(:newsletter, status: Newsletter::Status::PUBLISHED)
#
#       get :new
#       expect(response).to render_template('new')
#     end
#   end
#
#   context 'edit' do
#     it 'should allow to edit only if newsletter is in draft state', admin_sign_in: true do
#       newsletter = create(:newsletter, status: Newsletter::Status::DRAFT)
#       get :edit, id: newsletter.id
#
#       expect(response).to render_template('edit')
#     end
#
#     it 'should not allow to edit if newsletter is in published state', admin_sign_in: true do
#       Newsletter.update_all(status: Newsletter::Status::PUBLISHED)
#       newsletter = create(:newsletter, status: Newsletter::Status::PUBLISHED)
#       get :edit, id: newsletter.id
#
#       expect(response).not_to render_template('edit')
#     end
#   end
#
#   context 'create' do
#     it 'should create and redirect to edit_newsletter path', admin_sign_in: true do
#       post :create, newsletter: { name: 'june' }
#
#       newsletter = Newsletter.last
#       expect(response).to redirect_to(edit_newsletter_path(newsletter))
#     end
#
#     it 'should render new if error', admin_sign_in: true do
#       post :create, newsletter: { name: '' }
#
#       expect(response).to render_template('new')
#     end
#   end
#
#   context 'subscribe' do
#     it 'should subscribe to newsletter', admin_sign_in: true do
#       email = Faker::Internet.email
#
#       expect do
#         post :subscribe, email: email
#       end.to change { Subscriber.count }.by(1)
#
#       expect(Subscriber.last.email).to eq(email)
#       expect(flash[:notice]).to eq('Subscribed successfully')
#       expect(response).to redirect_to(root_path)
#     end
#
#     it 'should throw error if already subscribed to newsletter', admin_sign_in: true do
#       email = Faker::Internet.email
#       Subscriber.create(email: email)
#
#       expect do
#         post :subscribe, email: email
#       end.to_not change { Subscriber.count }
#
#       expect(flash[:alert]).to eq('Email already subscribed')
#       expect(response).to redirect_to(root_path)
#     end
#   end
# end
