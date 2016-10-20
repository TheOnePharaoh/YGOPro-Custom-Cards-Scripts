--Mechquipped Formation
function c19007849.initial_effect(c)
	--activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)
	--banish
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_TRIGGER_O+EFFECT_TYPE_FIELD)
	e2:SetCategory(CATEGORY_REMOVE)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetCode(EVENT_CHANGE_POS)
	e2:SetRange(LOCATION_FZONE)
	e2:SetCondition(c19007849.accon)
	e2:SetTarget(c19007849.actg)
	e2:SetOperation(c19007849.acop)
	c:RegisterEffect(e2)
	--disable spsummon
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetRange(LOCATION_FZONE)
	e3:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e3:SetTargetRange(LOCATION_GRAVE,LOCATION_GRAVE)
	c:RegisterEffect(e3)
	--pos1
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(19007849,0))
	e4:SetCategory(CATEGORY_POSITION)
	e4:SetType(EFFECT_TYPE_TRIGGER_O+EFFECT_TYPE_FIELD)
	e4:SetRange(LOCATION_FZONE)
	e4:SetCode(EVENT_BE_BATTLE_TARGET)
	e4:SetCondition(c19007849.poscon1)
	e4:SetTarget(c19007849.postg1)
	e4:SetOperation(c19007849.posop1)
	c:RegisterEffect(e4)
	--pos2
	local e5=Effect.CreateEffect(c)
	e5:SetDescription(aux.Stringid(19007849,1))
	e5:SetCategory(CATEGORY_POSITION)
	e5:SetType(EFFECT_TYPE_TRIGGER_O+EFFECT_TYPE_FIELD)
	e5:SetRange(LOCATION_FZONE)
	e5:SetCode(EVENT_BE_BATTLE_TARGET)
	e5:SetCondition(c19007849.poscon2)
	e5:SetTarget(c19007849.postg2)
	e5:SetOperation(c19007849.posop2)
	c:RegisterEffect(e5)
end
function c19007849.cfilter(c)
	local np=c:GetPosition()
	local pp=c:GetPreviousPosition()
	return not c:IsStatus(STATUS_CONTINUOUS_POS) and ((np<3 and pp>3) or (pp<3 and np>3))
end
function c19007849.accon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c19007849.cfilter,1,nil)
end
function c19007849.actg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:GetLocation()==LOCATION_GRAVE and chkc:IsAbleToRemove() end
	if chk==0 then return Duel.IsExistingTarget(Card.IsAbleToRemove,tp,LOCATION_GRAVE,LOCATION_GRAVE,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectTarget(tp,Card.IsAbleToRemove,tp,LOCATION_GRAVE,LOCATION_GRAVE,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,g,g:GetCount(),0,0)
end
function c19007849.acop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS)
	local sg=g:Filter(Card.IsRelateToEffect,nil,e)
	Duel.Remove(sg,POS_FACEUP,REASON_EFFECT)
end
function c19007849.poscon1(e,tp,eg,ep,ev,re,r,rp)
	local a=Duel.GetAttacker()
	local d=Duel.GetAttackTarget()
	return a:IsControler(tp) and a:IsSetCard(0xda3791) or a:IsSetCard(0xda3790) or a:IsCode(15914410) or a:IsCode(41309158) and d:IsFaceup()
end
function c19007849.postg1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.GetAttackTarget():CreateEffectRelation(e)
end
function c19007849.posop1(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetAttackTarget()
	if tc:IsFaceup() and tc:IsRelateToEffect(e) then
		Duel.ChangePosition(tc,POS_FACEUP_DEFENSE,0,POS_FACEUP_ATTACK,0)
	end
end
function c19007849.poscon2(e,tp,eg,ep,ev,re,r,rp)
	local a=Duel.GetAttacker()
	local d=Duel.GetAttackTarget()
	return a:IsControler(tp) and a:IsFaceup() and d:IsSetCard(0xda3791) or d:IsSetCard(0xda3790) or d:IsCode(15914410) or d:IsCode(41309158)
end
function c19007849.postg2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.GetAttackTarget():CreateEffectRelation(e)
end
function c19007849.posop2(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetAttackTarget()
	if tc:IsFaceup() and tc:IsRelateToEffect(e) then
		Duel.ChangePosition(tc,POS_FACEUP_DEFENSE,0,POS_FACEUP_ATTACK,0)
	end
end
