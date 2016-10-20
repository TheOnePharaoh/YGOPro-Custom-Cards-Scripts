--Card Populator
function c999.initial_effect(c)
	--Activate	
	local e1=Effect.CreateEffect(c)	
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_IGNORE_IMMUNE)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_PREDRAW)
	e1:SetCountLimit(1)
	e1:SetRange(0xff)
	e1:SetOperation(c999.op)
	c:RegisterEffect(e1)
end
function c999.op(e,tp,eg,ep,ev,re,r,rp,chk)
	if Duel.GetFlagEffect(tp,999)==0 and Duel.GetFlagEffect(1-tp,999)==0 then
		Duel.RegisterFlagEffect(tp,999,0,0,0)
		Duel.RegisterFlagEffect(1-tp,999,0,0,0)
		local c=e:GetHandler()
		Duel.Hint(HINT_CARD,0,999)
		Duel.ConfirmCards(1-tp,c)
		Duel.ConfirmCards(tp,c)
		local sg=Duel.GetMatchingGroup(Card.IsCode,tp,0xff,0xff,nil,999)
		Duel.SendtoDeck(sg,nil,-2,REASON_EFFECT)
		while Duel.SelectYesNo(1-tp,aux.Stringid(999,0)) do
			Duel.Hint(HINT_SELECTMSG,1-tp,0)
			local ac=Duel.AnnounceCard(1-tp)
			local token=Duel.CreateToken(1-tp,ac)
			if token:IsType(TYPE_PENDULUM) then
				Duel.Hint(HINT_SELECTMSG,1-tp,aux.Stringid(76922029,0))
				local op=Duel.SelectOption(1-tp,aux.Stringid(999,1),aux.Stringid(999,2))
				if op==0 then
					Duel.SendtoDeck(token,1-tp,2,REASON_EFFECT)
				else
					Duel.PSendtoExtra(token,1-tp,REASON_EFFECT)
				end
			else
				Duel.SendtoDeck(token,1-tp,2,REASON_EFFECT)
			end
		end
		while Duel.SelectYesNo(tp,aux.Stringid(999,0)) do
			Duel.Hint(HINT_SELECTMSG,tp,0)
			local ac=Duel.AnnounceCard(tp)
			local token=Duel.CreateToken(tp,ac)
			if token:IsType(TYPE_PENDULUM) then
				Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(76922029,0))
				local op=Duel.SelectOption(tp,aux.Stringid(999,1),aux.Stringid(999,2))
				if op==0 then
					Duel.SendtoDeck(token,tp,2,REASON_EFFECT)
				else
					Duel.PSendtoExtra(token,tp,REASON_EFFECT)
				end
			else
				Duel.SendtoDeck(token,tp,2,REASON_EFFECT)
			end
		end
	end
end
