--The Future Gear Great Xiaolong
function c99199025.initial_effect(c)
	--synchro summon
	aux.AddSynchroProcedure(c,aux.FilterBoolFunction(Card.IsSetCard,0xff15),aux.NonTuner(Card.IsAttribute,ATTRIBUTE_LIGHT),1)
	c:EnableReviveLimit()
	--draw
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(99199025,0))
	e1:SetCategory(CATEGORY_DRAW)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetCondition(c99199025.condition)
	e1:SetTarget(c99199025.target)
	e1:SetOperation(c99199025.operation)
	c:RegisterEffect(e1)
	--atkup
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e2:SetCode(EFFECT_UPDATE_ATTACK)
	e2:SetRange(LOCATION_MZONE)
	e2:SetValue(c99199025.atkval)
	c:RegisterEffect(e2)
	--draw1
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(99199025,1))
	e3:SetCategory(CATEGORY_DRAW)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCode(EVENT_SPSUMMON_SUCCESS)
	e3:SetCountLimit(1,99199025)
	e3:SetCondition(c99199025.drcon1)
	e3:SetTarget(c99199025.drtg)
	e3:SetOperation(c99199025.drop)
	c:RegisterEffect(e3)
	--draw2
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(99199025,2))
	e4:SetCategory(CATEGORY_DRAW)
	e4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e4:SetRange(LOCATION_MZONE)
	e4:SetCode(EVENT_SPSUMMON_SUCCESS)
	e4:SetCountLimit(1,99199025)
	e4:SetCondition(c99199025.drcon2)
	e4:SetTarget(c99199025.drtg)
	e4:SetOperation(c99199025.drop)
	c:RegisterEffect(e4)
	--draw3
	local e5=Effect.CreateEffect(c)
	e5:SetDescription(aux.Stringid(99199025,3))
	e5:SetCategory(CATEGORY_DRAW)
	e5:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e5:SetRange(LOCATION_MZONE)
	e5:SetCode(EVENT_SPSUMMON_SUCCESS)
	e5:SetCountLimit(1,99199025)
	e5:SetCondition(c99199025.drcon3)
	e5:SetTarget(c99199025.drtg)
	e5:SetOperation(c99199025.drop)
	c:RegisterEffect(e5)
end
function c99199025.condition(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetSummonType()==SUMMON_TYPE_SYNCHRO
end
function c99199025.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsPlayerCanDraw(tp,2) end
	Duel.SetTargetPlayer(tp)
	Duel.SetTargetParam(2)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,2)
end
function c99199025.operation(e,tp,eg,ep,ev,re,r,rp)
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	if Duel.Draw(p,d,REASON_EFFECT)<2 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local g=Duel.SelectMatchingCard(tp,Card.IsAbleToDeck,tp,LOCATION_HAND,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.BreakEffect()
		if Duel.SelectOption(tp,aux.Stringid(99199025,1),aux.Stringid(99199025,2))==0 then
			Duel.SendtoDeck(g,nil,0,REASON_EFFECT)
		else
			Duel.SendtoDeck(g,nil,1,REASON_EFFECT)
		end
	end
end
function c99199025.atkval(e,c)
	return Duel.GetMatchingGroupCount(c99199025.atkfilter,c:GetControler(),LOCATION_EXTRA,0,nil)*200
end
function c99199025.atkfilter(c)
	return c:IsFaceup() and c:IsSetCard(0xff15)
end
function c99199025.drafilter(c)
	return c:IsFaceup() and c:IsSetCard(0xff15)
end
function c99199025.drcon1(e,tp,eg,ep,ev,re,r,rp)
	local tg=eg:GetFirst()
	return eg:GetFirst():GetSummonType()==SUMMON_TYPE_FUSION and eg:GetFirst():IsControler(tp) and eg:IsExists(c99199025.drafilter,1,nil)
end
function c99199025.drcon2(e,tp,eg,ep,ev,re,r,rp)
	local tg=eg:GetFirst()
	return eg:GetFirst():GetSummonType()==SUMMON_TYPE_SYNCHRO and eg:GetFirst():IsControler(tp) and eg:IsExists(c99199025.drafilter,1,nil)
end
function c99199025.drcon3(e,tp,eg,ep,ev,re,r,rp)
	local tg=eg:GetFirst()
	return eg:GetFirst():GetSummonType()==SUMMON_TYPE_XYZ and eg:GetFirst():IsControler(tp) and eg:IsExists(c99199025.drafilter,1,nil)
end
function c99199025.drtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsRelateToEffect(e) end
	Duel.SetTargetPlayer(tp)
	Duel.SetTargetParam(1)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,1)
end
function c99199025.drop(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) or e:GetHandler():IsFacedown() then return end
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	Duel.Draw(p,d,REASON_EFFECT)
end