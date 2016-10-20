--Cyber Dragon Termination
function c98729873.initial_effect(c)
	--xyz summon
	aux.AddXyzProcedure(c,aux.FilterBoolFunction(Card.IsRace,RACE_MACHINE),5,2)
	c:EnableReviveLimit()
	--is cyber dragon nova
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_CHANGE_CODE)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetValue(58069384)
	c:RegisterEffect(e1)
	--Summon Cyber Twin Dragon
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)	
	e2:SetDescription(aux.Stringid(98729873,0))
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCost(c98729873.cost)
	e2:SetTarget(c98729873.target)
	e2:SetOperation(c98729873.operation)
	c:RegisterEffect(e2)
	--to grave
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(98729873,1))
	e3:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e3:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
	e3:SetCode(EVENT_TO_GRAVE)
	e3:SetTarget(c98729873.tg)
	e3:SetOperation(c98729873.op)
	c:RegisterEffect(e3)
end

function c98729873.cfilter(c)
	return c:IsFaceup() and c:IsCode(58069384) and c:IsAbleToGraveAsCost() 
end
function c98729873.cost(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_COST) and Duel.IsExistingMatchingCard(c98729873.cfilter,tp,LOCATION_MZONE,0,1,nil) end
    e:GetHandler():RemoveOverlayCard(tp,1,1,REASON_COST)
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
    local g=Duel.SelectMatchingCard(tp,c98729873.cfilter,tp,LOCATION_MZONE,0,1,1,nil)
    Duel.SendtoGrave(g,REASON_COST)
end

function c98729873.sfilter(c, e, tp)
	return c:IsCode(74157028) 
end

function c98729873.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c98729873.sfilter,tp,LOCATION_EXTRA,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
end

function c98729873.operation(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c98729873.sfilter,tp,LOCATION_EXTRA,0,1,1,nil,e,tp)
	if g:GetCount()>0 then
		Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
	end
end
function c98729873.filter(c,e,tp)
	return c:IsRace(RACE_MACHINE) and c:GetCode()~=98729873 and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end

function c98729873.tg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_GRAVE) and chkc:IsControler(tp) and c98729873.filter(chkc,e,tp) end
	if chk==0 then return true end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectTarget(tp,c98729873.filter,tp,LOCATION_GRAVE,0,1,1,nil,e,tp)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,g,1,0,0)
end

function c98729873.op(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc and tc:IsRelateToEffect(e) then
		Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP)
	end
end