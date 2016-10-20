--Lizardfolk - Brute
function c20161995.initial_effect(c)
	c:SetUniqueOnField(1,0,20161995)
	--spsummon
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(20161995,0))
	e1:SetCategory(CATEGORY_DRAW)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_SUMMON_SUCCESS)
	e1:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_DELAY)
	e1:SetCountLimit(1,20161995)
	e1:SetCost(c20161995.drcost)
	e1:SetTarget(c20161995.drtarg)
	e1:SetOperation(c20161995.drop)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetCode(EVENT_FLIP_SUMMON_SUCCESS)
	c:RegisterEffect(e2)
	local e3=e1:Clone()
	e3:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e3)
	--pierce
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_FIELD)
	e4:SetCode(EFFECT_PIERCE)
	e4:SetRange(LOCATION_MZONE)
	e4:SetTargetRange(LOCATION_MZONE,0)
	e4:SetTarget(c20161995.pitg)
	c:RegisterEffect(e4)
	--shuffle
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_FIELD)
	e5:SetProperty(EFFECT_FLAG_SET_AVAILABLE+EFFECT_FLAG_IGNORE_RANGE)
	e5:SetCode(EFFECT_TO_GRAVE_REDIRECT)
	e5:SetRange(LOCATION_MZONE)
	e5:SetTarget(c20161995.rmtarget)
	e5:SetTargetRange(0,0xff)
	e5:SetValue(LOCATION_DECKBOT)
	c:RegisterEffect(e5)
	--adjust
	local e6=Effect.CreateEffect(c)
	e6:SetType(EFFECT_TYPE_FIELD)
	e6:SetCode(20161995)
	e6:SetRange(LOCATION_MZONE)
	e6:SetProperty(EFFECT_FLAG_SET_AVAILABLE)
	e6:SetTargetRange(0,0xff)
	e6:SetTarget(c20161995.checktg)
	c:RegisterEffect(e6)
end
function c20161995.cfilter(c)
	return c:IsAbleToDeckAsCost()
end
function c20161995.drcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c20161995.cfilter,tp,LOCATION_HAND,0,3,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local g=Duel.SelectMatchingCard(tp,c20161995.cfilter,tp,LOCATION_HAND,0,3,3,nil)
	Duel.SendtoDeck(g,nil,1,REASON_COST)
end
function c20161995.drtarg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsPlayerCanDraw(tp,3) end
	Duel.SetTargetPlayer(tp)
	Duel.SetTargetParam(3)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,3)
end
function c20161995.drop(e,tp,eg,ep,ev,re,r,rp)
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	Duel.Draw(p,d,REASON_EFFECT)
end
function c20161995.pitg(e,c)
	return c:IsSetCard(0xab90) or c:IsSetCard(0xab91) or c:IsSetCard(0xab92)
end
function c20161995.rmtarget(e,c)
	return not c:IsLocation(0x80) and not c:IsType(TYPE_SPELL+TYPE_TRAP)
end
function c20161995.checktg(e,c)
	return not c:IsPublic()
end
