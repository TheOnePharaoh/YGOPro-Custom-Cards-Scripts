--The Future Gear Knight
function c99199019.initial_effect(c)
	c:SetSPSummonOnce(99199019)
	--pendulum summon
	aux.EnablePendulumAttribute(c)
	--splimit
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetRange(LOCATION_PZONE)
	e2:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_CANNOT_DISABLE)
	e2:SetTargetRange(1,0)
	e2:SetTarget(c99199019.splimit)
	e2:SetCondition(c99199019.splimcon)
	c:RegisterEffect(e2)
	--spsummon
	local e3=Effect.CreateEffect(c)
	e3:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e3:SetCode(EVENT_SUMMON_SUCCESS)
	e3:SetTarget(c99199019.target)
	e3:SetOperation(c99199019.operation)
	c:RegisterEffect(e3)
	local e4=e3:Clone()
	e4:SetCode(EVENT_SPSUMMON_SUCCESS)
	e4:SetCondition(c99199019.condition)
	c:RegisterEffect(e4)
	--special summon
	local e5=Effect.CreateEffect(c)
	e5:SetDescription(aux.Stringid(99199019,0))
	e5:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e5:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e5:SetCode(EVENT_SUMMON_SUCCESS)
	e5:SetRange(LOCATION_PZONE)
	e5:SetCountLimit(1,99199019)
	e5:SetCondition(c99199019.spcon)
	e5:SetTarget(c99199019.sptg)
	e5:SetOperation(c99199019.spop)
	c:RegisterEffect(e5)
end
function c99199019.splimit(e,c,sump,sumtype,sumpos,targetp)
	if c:IsSetCard(0xff15) then return false end
	return bit.band(sumtype,SUMMON_TYPE_PENDULUM)==SUMMON_TYPE_PENDULUM
end
function c99199019.splimcon(e)
	return not e:GetHandler():IsForbidden()
end
function c99199019.condition(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetSummonType()==SUMMON_TYPE_PENDULUM
end
function c99199019.filter(c,e,tp)
	return c:IsLevelBelow(6) and c:IsSetCard(0xff15) and not c:IsCode(57777714) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c99199019.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_DECK) and chkc:IsControler(tp) and c99199019.filter(chkc,e,tp) end
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingTarget(c99199019.filter,tp,LOCATION_DECK,0,1,nil,e,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectTarget(tp,c99199019.filter,tp,LOCATION_DECK,0,1,1,nil,e,tp)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,g,1,0,0)
end
function c99199019.operation(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP)
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e1:SetCode(EVENT_PHASE+PHASE_END)
		e1:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
		e1:SetRange(LOCATION_MZONE)
		e1:SetCountLimit(1)
		e1:SetOperation(c99199019.desop)
		e1:SetReset(RESET_EVENT+0x1fe0000)
		tc:RegisterEffect(e1)
	end
end
function c99199019.desop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Destroy(e:GetHandler(),REASON_EFFECT)
end
function c99199019.cfilter(c)
	return c:IsFaceup() and c:IsSetCard(0xff15)
end
function c99199019.spcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c99199019.cfilter,1,nil,tp)
end
function c99199019.specfilter(c,e,tp)
	return c:IsSetCard(0xff15) and c:IsLevelBelow(4) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c99199019.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	local tc=eg:GetFirst()
	if chk==0 then return Duel.IsExistingTarget(c99199019.specfilter,tp,LOCATION_HAND,0,1,nil,e,tp)
	and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND)
end
function c99199019.spop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	if not e:GetHandler():IsRelateToEffect(e) then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c99199019.specfilter,tp,LOCATION_HAND,0,1,1,nil,e,tp)
	if g:GetCount()>0 then
		Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
	end
end
