--Max Point, ANTI-MATTER Ending
function c1143239.initial_effect(c)
	--activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)
	--decrease tribute
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_DECREASE_TRIBUTE)
	e2:SetRange(LOCATION_SZONE)
	e2:SetTargetRange(LOCATION_HAND,0)
	e2:SetTarget(aux.TargetBoolFunction(Card.IsSetCard,0xaf75))
	e2:SetValue(0x1)
	c:RegisterEffect(e2)
	--draw
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(1143239,0))
	e3:SetCategory(CATEGORY_REMOVE)
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetRange(LOCATION_SZONE)
	e3:SetCountLimit(1)
	e3:SetCost(c1143239.drcost)
	e3:SetTarget(c1143239.drtg)
	e3:SetOperation(c1143239.drop)
	c:RegisterEffect(e3)
	--banish
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(1143239,1))
	e4:SetCategory(CATEGORY_REMOVE)
	e4:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e4:SetCode(EVENT_REMOVE)
	e4:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
	e4:SetTarget(c1143239.rmtg)
	e4:SetOperation(c1143239.rmop)
	if not c1143239.global_check then
		c1143239.global_check=true
		local ge1=Effect.GlobalEffect()
		ge1:SetType(EFFECT_TYPE_FIELD)
		ge1:SetCode(EFFECT_TO_GRAVE_REDIRECT)
		ge1:SetTargetRange(LOCATION_DECK+LOCATION_HAND+LOCATION_SZONE+LOCATION_OVERLAY,LOCATION_DECK+LOCATION_HAND+LOCATION_SZONE+LOCATION_OVERLAY)
		ge1:SetTarget(aux.TargetBoolFunction(Card.IsCode,1143239))
		ge1:SetValue(LOCATION_REMOVED)
		Duel.RegisterEffect(ge1,0)
	end
end
function c1143239.drcost(e,tp,eg,ep,ev,re,r,rp,chk)
	local g=Duel.GetDecktopGroup(tp,4)
	if chk==0 then return g:IsExists(Card.IsAbleToRemove,4,nil) end
	Duel.DisableShuffleCheck()
	Duel.Remove(g,POS_FACEUP,REASON_COST)
end
function c1143239.drtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsPlayerCanDraw(tp,2) end
	Duel.SetTargetPlayer(tp)
	Duel.SetTargetParam(2)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,2)
end
function c1143239.drop(e,tp,eg,ep,ev,re,r,rp)
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	Duel.Draw(p,d,REASON_EFFECT)
end
function c1143239.scfilter(c)
	return c:IsFaceup() and c:IsSetCard(0xaf75)
end
function c1143239.tfilter(c)
	return not c:IsAbleToRemove()
end
function c1143239.rmtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		local g=Duel.GetMatchingGroup(c1143239.scfilter,tp,LOCATION_MZONE,0,nil)
		return g:GetCount()>0 and not g:IsExists(c1143239.tfilter,1,nil)
	end
	local g=Duel.GetMatchingGroup(c1143239.scfilter,tp,LOCATION_MZONE,0,nil)
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,g,g:GetCount(),0,0)
end
function c1143239.rmop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(c1143239.scfilter,tp,LOCATION_MZONE,0,nil)
	Duel.Remove(g,POS_FACEUP,REASON_EFFECT)
end
