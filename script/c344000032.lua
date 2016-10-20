function c344000032.initial_effect(c)
	--fusion material
	c:EnableReviveLimit()
	aux.AddFusionProcCodeFun(c,344000012,aux.FilterBoolFunction(Card.IsRace,RACE_MACHINE),1,false,false)
	
		local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(344000032,0))
	e1:SetCategory(CATEGORY_DRAW)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_BATTLE_DESTROYING)
	e1:SetCondition(c344000032.con)
	e1:SetTarget(c344000032.tg)
	e1:SetOperation(c344000032.op)
	c:RegisterEffect(e1)
end
function c344000032.con(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local a=Duel.GetAttacker()
	local d=Duel.GetAttackTarget()
	return (c==a and d:IsLocation(LOCATION_GRAVE)) or (c==d and a:IsLocation(LOCATION_GRAVE))
end
function c344000032.tg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsPlayerCanDraw(tp,1) end
	Duel.SetTargetPlayer(tp)
	Duel.SetTargetParam(1)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,1)
end
function c344000032.op(e,tp,eg,ep,ev,re,r,rp)
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	Duel.Draw(p,d,REASON_EFFECT)
end
