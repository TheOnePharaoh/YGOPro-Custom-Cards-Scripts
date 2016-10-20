-- ADE Nauglamr
function c70649930.initial_effect(c)
	--pendulum summon
	aux.EnablePendulumAttribute(c)
	--splimit
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetRange(LOCATION_PZONE)
	e2:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_CANNOT_DISABLE)
	e2:SetTargetRange(1,0)
	e2:SetTarget(c70649930.splimit)
	e2:SetCondition(c70649930.splimcon)
	c:RegisterEffect(e2)
	--atk
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetCode(EFFECT_UPDATE_ATTACK)
	e3:SetRange(LOCATION_PZONE)
	e3:SetTargetRange(LOCATION_MZONE,0)
	e3:SetTarget(c70649930.efilter)
	e3:SetValue(300)
	c:RegisterEffect(e3)
	--special summon
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(70649930,0))
	e4:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e4:SetRange(LOCATION_HAND)
	e4:SetCode(EVENT_DESTROYED)
	e4:SetCondition(c70649930.spcon)
	e4:SetTarget(c70649930.sptg)
	e4:SetOperation(c70649930.spop)
	c:RegisterEffect(e4)
	--remove
	local e5=Effect.CreateEffect(c)
	e5:SetDescription(aux.Stringid(70649902,1))
	e5:SetCategory(CATEGORY_REMOVE)
	e5:SetType(EFFECT_TYPE_TRIGGER_O+EFFECT_TYPE_SINGLE)
	e5:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_DAMAGE_STEP)
	e5:SetCode(EVENT_DESTROYED)
	e5:SetCondition(c70649930.remcon)
	e5:SetTarget(c70649930.remtg)
	e5:SetOperation(c70649930.remop)
	c:RegisterEffect(e5)
end
function c70649930.splimit(e,c,sump,sumtype,sumpos,targetp)
	if c:IsType(TYPE_MONSTER) and c:IsSetCard(0xd0a214) then return false end
	return bit.band(sumtype,SUMMON_TYPE_PENDULUM)==SUMMON_TYPE_PENDULUM
end
function c70649930.splimcon(e)
	return not e:GetHandler():IsForbidden()
end
function c70649930.efilter(e,c)
	return c:IsRace(RACE_DRAGON)
end
function c70649930.cfilter(c,tp)
	return c:IsType(TYPE_MONSTER) and c:IsReason(REASON_EFFECT) and c:GetPreviousControler()==tp
end
function c70649930.spcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c70649930.cfilter,1,nil,tp)
end
function c70649930.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function c70649930.spop(e,tp,eg,ep,ev,re,r,rp)
	if e:GetHandler():IsRelateToEffect(e) then
		Duel.SpecialSummon(e:GetHandler(),0,tp,tp,false,false,POS_FACEUP)
	end
end
function c70649930.remcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsReason(REASON_EFFECT) and e:GetHandler():IsReason(REASON_DESTROY)
end
function c70649930.remtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsOnField() and chkc:IsAbleToRemove() end
	if chk==0 then return Duel.IsExistingTarget(Card.IsAbleToRemove,tp,0,LOCATION_MZONE,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectTarget(tp,Card.IsAbleToRemove,tp,0,LOCATION_MZONE,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,g,1,0,0)
end
function c70649930.remop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		Duel.Remove(tc,POS_FACEUP,REASON_EFFECT)
	end
end