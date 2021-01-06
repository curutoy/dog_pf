require 'rails_helper'

RSpec.describe "Messages", type: :request do
  let!(:user)      { create(:user) }
  let!(:protector) { create(:protector) }
  let!(:room)      { create(:room) }
  let!(:entry)     { create(:entry, user: user, protector: protector, room: room) }
  let!(:message)   { build(:message, user: user, protector: protector, room: room) }


  describe "GET /create" do
    context "userがサインインしている場合" do
      before do
        sign_in user
      end

      context "入力内容に誤りがない場合" do
        it "status codeが302となること" do
          post messages_path, params: { message: {
            protector_id: protector.id,
            room_id: room.id,
            content: "test content",
          } }
          expect(response).to have_http_status(302)
        end

        it "メッセージ送信が成功すること" do
          expect do
            post messages_path, params: { message: {
              protector_id: protector.id,
              room_id: room.id,
              content: "test content",
            } }
          end.to change(Message, :count).by(1)
        end

        it "notificationが作成されること" do
          expect do
            post messages_path, params: { message: {
              protector_id: protector.id,
              room_id: room.id,
              content: "test content",
              message_id: message.id,
              visited_protector_id: protector.id,
              action: 'dm'
            } }
          end.to change(Notification, :count).by(1)
        end

        it "room画面へリダイレクトすること" do
          post messages_path, params: { message: {
            protector_id: protector.id,
            room_id: room.id,
            content: "test content",
          } }
          expect(response).to redirect_to room_path(room.id)
        end
      end

      context "入力が誤っていた場合" do
        it "status codeが302となること" do
          post messages_path, params: { message: {
            protector_id: protector.id,
            room_id: room.id,
            content: " ",
          } }
          expect(response).to have_http_status(302)
        end

        it "メッセージ送信が成功すること" do
          expect do
            post messages_path, params: { message: {
              protector_id: protector.id,
              room_id: room.id,
              content: " ",
            } }
          end.not_to change(Message, :count)
        end

        it "room画面へリダイレクトされること" do
          post messages_path, params: { message: {
            protector_id: protector.id,
            room_id: room.id,
            content: "test content",
          } }
          expect(response).to redirect_to room_path(room.id)
        end
      end
    end

    context "protectorがサインインしている場合" do
      before do
        sign_in protector
      end

      context "入力内容に誤りがない場合" do
        it "status codeが302となること" do
          post messages_path, params: { message: {
            user_id: user.id,
            room_id: room.id,
            content: "test content",
          } }
          expect(response).to have_http_status(302)
        end

        it "メッセージ送信が成功すること" do
          expect do
            post messages_path, params: { message: {
              user_id: user.id,
              room_id: room.id,
              content: "test content",
            } }
          end.to change(Message, :count).by(1)
        end

        it "notificationが作成されること" do
          expect do
            post messages_path, params: { message: {
              user_id: user.id,
              room_id: room.id,
              content: "test content",
              message_id: message.id,
              visited_user_id: user.id,
              action: 'dm'
            } }
          end.to change(Notification, :count).by(1)
        end

        it "room画面へリダイレクトすること" do
          post messages_path, params: { message: {
            user_id: user.id,
            room_id: room.id,
            content: "test content",
          } }
          expect(response).to redirect_to room_path(room.id)
        end
      end

      context "入力が誤っていた場合" do
        it "status codeが302となること" do
          post messages_path, params: { message: {
            user_id: user.id,
            room_id: room.id,
            content: " ",
          } }
          expect(response).to have_http_status(302)
        end

        it "メッセージ送信が成功すること" do
          expect do
            post messages_path, params: { message: {
              user_id: user.id,
              room_id: room.id,
              content: " ",
            } }
          end.not_to change(Message, :count)
        end

        it "room画面へリダイレクトされること" do
          post messages_path, params: { message: {
            user_id: user.id,
            room_id: room.id,
            content: "test content",
          } }
          expect(response).to redirect_to room_path(room.id)
        end
      end
    end
  end
end
