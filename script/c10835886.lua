--Gem-knight God Diamond
function c10835886.initial_effect(c)
	--fusion material
	c:EnableReviveLimit()
	aux.AddFusionProcCode2(c,39512984,19355597,true,true)
	--spsummon condition
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetCode(EFFECT_SPSUMMON_CONDITION)
	e1:SetValue(c10835886.splimit)
	c:RegisterEffect(e1)
	--atkup
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCode(EFFECT_UPDATE_ATTACK)
	e2:SetValue(c10835886.atkup)
	c:RegisterEffect(e2)
	--search
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(10835886,0))
	e3:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCountLimit(1,10835886)
	e3:SetTarget(c10835886.target)
	e3:SetOperation(c10835886.operation)
	c:RegisterEffect(e3)
	--spsummon
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(10835886,1))
	e4:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e4:SetType(EFFECT_TYPE_IGNITION)
	e4:SetRange(LOCATION_MZONE)
	e4:SetCountLimit(1,10835886)
	e4:SetCost(c10835886.spcost)
	e4:SetTarget(c10835886.sptg)
	e4:SetOperation(c10835886.spop)
	c:RegisterEffect(e4)
	--Destroy replace
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_SINGLE)
	e5:SetCode(EFFECT_DESTROY_REPLACE)
	e5:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e5:SetRange(LOCATION_MZONE)
	e5:SetTarget(c10835886.desreptg)
	c:RegisterEffect(e5)
end
function c10835886.splimit(e,se,sp,st)
	return not e:GetHandler():IsLocation(LOCATION_EXTRA) or bit.band(st,SUMMON_TYPE_FUSION)==SUMMON_TYPE_FUSION
end
function c10835886.atkfilter(c)
	return c:IsSetCard(0x47) and c:IsType(TYPE_MONSTER)
end
function c10835886.atkup(e,c)
	return Duel.GetMatchingGroupCount(c10835886.atkfilter,c:GetControler(),LOCATION_MZONE+LOCATION_REMOVED,0,nil)*300
end
function c10835886.thfilter(c)
	return c:IsCode(1264319) or c:IsCode(39261576) or c:IsCode(71422989) or c:IsCode(7394770) or c:IsCode(55824220) or c:IsCode(72029628) and c:IsAbleToHand()
end
function c10835886.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c10835886.thfilter,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK+LOCATION_GRAVE)
end
function c10835886.operation(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c10835886.thfilter,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end
function c10835886.cfilter(c)
	return c:IsFaceup() and c:IsSetCard(0x47) and not c:IsCode(10835886) and c:IsAbleToGraveAsCost() or c:IsSetCard(0x47) and c:IsDiscardable()
end
function c10835886.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c10835886.cfilter,tp,LOCATION_MZONE+LOCATION_HAND,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectMatchingCard(tp,c10835886.cfilter,tp,LOCATION_MZONE+LOCATION_HAND,0,1,1,nil)
	Duel.SendtoGrave(g,REASON_COST)
end
function c10835886.filter(c,e,tp)
	return c:IsType(TYPE_FUSION) and c:IsSetCard(0x47) and not c:IsCode(10835886) and c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_FUSION,tp,true,false)
end
function c10835886.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>-1
		and Duel.IsExistingMatchingCard(c10835886.filter,tp,LOCATION_EXTRA,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
end
function c10835886.spop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c10835886.filter,tp,LOCATION_EXTRA,0,1,1,nil,e,tp)
	local tc=g:GetFirst()
	if tc and Duel.SpecialSummonStep(tc,SUMMON_TYPE_FUSION,tp,tp,true,false,POS_FACEUP) then
			local e1=Effect.CreateEffect(e:GetHandler())
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_UPDATE_ATTACK)
			e1:SetValue(2250)
			e1:SetReset(RESET_EVENT+0x1fe0000)
			tc:RegisterEffect(e1)
	end
end
function c10835886.repfilter(c)
	return c:IsSetCard(0x47) and not c:IsCode(10835886)
end
function c10835886.desreptg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return not c:IsReason(REASON_REPLACE)
		and Duel.IsExistingMatchingCard(c10835886.repfilter,tp,LOCATION_HAND+LOCATION_MZONE,0,1,nil) end
	if Duel.SelectYesNo(tp,aux.Stringid(10835886,2)) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
		local g=Duel.SelectMatchingCard(tp,c10835886.repfilter,tp,LOCATION_HAND+LOCATION_MZONE,0,1,1,nil)
		Duel.SendtoGrave(g,REASON_EFFECT+REASON_REPLACE)
		return true
	else return false end
end
