--False Embodiment
function c68691243.initial_effect(c)
	c:SetUniqueOnField(1,0,68691243)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)
	--token
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e2:SetRange(LOCATION_SZONE)
	e2:SetCode(EVENT_CHAIN_SOLVED)
	e2:SetCondition(c68691243.tokencon)
	e2:SetOperation(c68691243.tokenop)
	c:RegisterEffect(e2)
	--draw
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(68691243,0))
	e3:SetCategory(CATEGORY_DRAW)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e3:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_DELAY)
	e3:SetCode(EVENT_TO_GRAVE)
	e3:SetCountLimit(1,68691243)
	e3:SetCondition(c68691243.drcon)
	e3:SetTarget(c68691243.drtg)
	e3:SetOperation(c68691243.drop)
	c:RegisterEffect(e3)
end
function c68691243.tokencon(e,tp,eg,ep,ev,re,r,rp)
	if not re then return false end
	local c=re:GetHandler()
	return re:IsHasType(EFFECT_TYPE_ACTIVATE) and re:IsActiveType(TYPE_SPELL+TYPE_TRAP) and c:IsSetCard(0x0dac406) and Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsPlayerCanSpecialSummonMonster(tp,68691245,0,0x4011,0,200,1,RACE_MACHINE,ATTRIBUTE_LIGHT)
end
function c68691243.tokenop(e,tp,eg,ep,ev,re,r,rp)
	local token=Duel.CreateToken(tp,68691245)
	Duel.SpecialSummon(token,0,tp,tp,false,false,POS_FACEUP_DEFENSE)
end
function c68691243.drcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c:GetPreviousControler()==tp and rp~=tp and c:IsReason(REASON_DESTROY)
end
function c68691243.drtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsPlayerCanDraw(tp,2) end
	Duel.SetTargetPlayer(tp)
	Duel.SetTargetParam(2)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,2)
end
function c68691243.drop(e,tp,eg,ep,ev,re,r,rp)
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	Duel.Draw(p,d,REASON_EFFECT)
end
