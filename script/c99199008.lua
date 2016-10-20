--The Future Gear Great Gunslinger
function c99199008.initial_effect(c)
	--pendulum summon
	aux.EnablePendulumAttribute(c)
	--splimit
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetRange(LOCATION_PZONE)
	e2:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_CANNOT_DISABLE)
	e2:SetTargetRange(1,0)
	e2:SetTarget(c99199008.splimit)
	e2:SetCondition(c99199008.splimcon)
	c:RegisterEffect(e2)
	--special summon
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(99199008,0))
	e3:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e3:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetRange(LOCATION_PZONE)
	e3:SetCountLimit(1)
	e3:SetCost(c99199008.spcost)
	e3:SetTarget(c99199008.sptg)
	e3:SetOperation(c99199008.spop)
	c:RegisterEffect(e3)
	--to hand
	local e4=Effect.CreateEffect(c)
	e4:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e4:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e4:SetCode(EVENT_SUMMON_SUCCESS)
	e4:SetCountLimit(1,99199008)
	e4:SetTarget(c99199008.thtg)
	e4:SetOperation(c99199008.thop)
	c:RegisterEffect(e4)
	local e5=e4:Clone()
	e5:SetCode(EVENT_SPSUMMON_SUCCESS)
	e5:SetCondition(c99199008.thcon)
	c:RegisterEffect(e5)
	--scale
	local e6=Effect.CreateEffect(c)
	e6:SetType(EFFECT_TYPE_SINGLE)
	e6:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e6:SetCode(EFFECT_CHANGE_LSCALE)
	e6:SetRange(LOCATION_PZONE)
	e6:SetCondition(c99199008.sccon)
	e6:SetValue(4)
	c:RegisterEffect(e6)
	local e7=e6:Clone()
	e7:SetCode(EFFECT_CHANGE_RSCALE)
	c:RegisterEffect(e7)
end
function c99199008.splimit(e,c,sump,sumtype,sumpos,targetp)
	if c:IsSetCard(0xff15) then return false end
	return bit.band(sumtype,SUMMON_TYPE_PENDULUM)==SUMMON_TYPE_PENDULUM
end
function c99199008.splimcon(e)
	return not e:GetHandler():IsForbidden()
end
function c99199008.costfilter(c)
	return c:IsAttribute(ATTRIBUTE_LIGHT)
end
function c99199008.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.CheckLPCost(tp,800) and Duel.CheckReleaseGroup(tp,c99199008.costfilter,1,nil) end
	Duel.PayLPCost(tp,800)
	local sg=Duel.SelectReleaseGroup(tp,c99199008.costfilter,1,1,nil)
	Duel.Release(sg,REASON_COST)
end
function c99199008.spefilter(c,e,tp)
	return c:IsType(TYPE_MONSTER) and c:IsSetCard(0xff15) and c:IsLevelBelow(4) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c99199008.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>-1
		and Duel.IsExistingMatchingCard(c99199008.spefilter,tp,LOCATION_GRAVE,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_GRAVE)
end
function c99199008.spop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c99199008.spefilter,tp,LOCATION_GRAVE,0,1,1,nil,e,tp)
	if g:GetCount()>0 then Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)	end
end
function c99199008.thcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetSummonType()==SUMMON_TYPE_PENDULUM
end
function c99199008.thfilter(c)
	return c:IsFaceup() and c:IsSetCard(0xff15) and c:IsType(TYPE_PENDULUM) and not c:IsCode(99199008) and c:IsAbleToHand()
end
function c99199008.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c99199008.thfilter,tp,LOCATION_EXTRA,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_EXTRA)
end
function c99199008.thop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c99199008.thfilter,tp,LOCATION_EXTRA,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end
function c99199008.sccon(e)
	local seq=e:GetHandler():GetSequence()
	local tc=Duel.GetFieldCard(e:GetHandlerPlayer(),LOCATION_SZONE,13-seq)
	return not tc or not tc:IsSetCard(0xff15)
end
