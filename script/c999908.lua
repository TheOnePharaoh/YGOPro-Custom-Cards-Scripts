--Red Dragon Princess
function c999908.initial_effect(c)
	--synchro summon
	aux.AddSynchroProcedure(c,nil,aux.NonTuner(nil),1)
	c:EnableReviveLimit()
	--draw
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(999908,0))
	e1:SetCategory(CATEGORY_DRAW)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetCondition(c999908.drcon)
	e1:SetTarget(c999908.drtg)
	e1:SetOperation(c999908.drop)
	c:RegisterEffect(e1)
end
function c999908.drcon(e,tp,eg,ep,ev,re,r,rp)
	local tg=eg:GetFirst()
	return eg:GetCount()==1 and tg:GetSummonType()==SUMMON_TYPE_SYNCHRO
end
function c999908.drtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetTargetPlayer(tp)
	Duel.SetTargetParam(1)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,1)
end
function c999908.drop(e,tp,eg,ep,ev,re,r,rp)
	local tg=eg:GetFirst()
	if tg~=e:GetHandler() then
		if not e:GetHandler():IsRelateToEffect(e) or e:GetHandler():IsFacedown() then return end
	end
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	Duel.Draw(p,d,REASON_EFFECT)
end
