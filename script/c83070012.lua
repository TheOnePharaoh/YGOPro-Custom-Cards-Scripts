--Hydrush Draw
function c83070012.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_DRAW)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,83070012+EFFECT_COUNT_CODE_OATH)
	e1:SetTarget(c83070012.target)
	e1:SetOperation(c83070012.activate)
	c:RegisterEffect(e1)
end
function c83070012.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsPlayerCanDraw(tp,1) end
	Duel.SetTargetPlayer(tp)
	Duel.SetTargetParam(1)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,1)
end
function c83070012.activate(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	Duel.Draw(p,d,REASON_EFFECT)
	if c:GetControler()==c:GetOwner() then
		if Duel.GetLocationCount(1-tp,LOCATION_SZONE)>0 then
			Duel.BreakEffect()
			Duel.SendtoGrave(c,REASON_RULE)
			Duel.SSet(1-tp,c)
			Duel.ConfirmCards(tp,c)
		else
			Duel.Destroy(c,REASON_EFFECT)
		end
	end
end
