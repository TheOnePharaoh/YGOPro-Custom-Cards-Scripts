--D.S. Shark
function c29001789.initial_effect(c)
	--synchro summon
	aux.AddSynchroProcedure(c,aux.FilterBoolFunction(Card.IsAttribute,ATTRIBUTE_WATER),aux.NonTuner(Card.IsRace,RACE_FISH),1)
	c:EnableReviveLimit()
	--synchro summon success
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(29001789,0))
	e1:SetCategory(CATEGORY_DRAW)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetCondition(c29001789.drcon)
	e1:SetTarget(c29001789.drtarg)
	e1:SetOperation(c29001789.drop)
	c:RegisterEffect(e1)
	--atkup
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCode(EFFECT_UPDATE_ATTACK)
	e2:SetCondition(c29001789.atkcon)
	e2:SetValue(c29001789.atkval)
	c:RegisterEffect(e2)
	--nontuner
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCode(EFFECT_NONTUNER)
	e3:SetCondition(c29001789.atkcon)
	c:RegisterEffect(e3)
end
function c29001789.drcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetSummonType()==SUMMON_TYPE_SYNCHRO
end
function c29001789.drtarg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsPlayerCanDraw(tp,1) end
	Duel.SetTargetPlayer(tp)
	Duel.SetTargetParam(1)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,1)
end
function c29001789.drop(e,tp,eg,ep,ev,re,r,rp)
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	Duel.Draw(p,d,REASON_EFFECT)
end
function c29001789.umifilter(c)
	return c:IsFaceup() and c:IsCode(22702055)
end
function c29001789.atkcon(e)
	return Duel.IsExistingMatchingCard(c29001789.umifilter,0,LOCATION_ONFIELD,LOCATION_ONFIELD,1,nil)
		or Duel.IsEnvironment(22702055)
end
function c29001789.atkfilter(c)
	return c:IsSetCard(0x10a7) and c:IsType(TYPE_TUNER)
end
function c29001789.atkval(e,c)
	return Duel.GetMatchingGroupCount(c29001789.atkfilter,c:GetControler(),LOCATION_GRAVE,0,nil)*200
end
