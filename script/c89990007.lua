--ekrix the spirit of the mystical king
function c89990007.initial_effect(c)
	--limit summon
	c:EnableReviveLimit()
	--special proc
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e1:SetRange(LOCATION_HAND)
	e1:SetCondition(c89990007.spcon)
	e1:SetOperation(c89990007.spop)
	c:RegisterEffect(e1)
	--special summon
	local e2=Effect.CreateEffect(c)
	e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_SPSUMMON_CONDITION)
	c:RegisterEffect(e2)
	--selfdestroy
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCode(EFFECT_SELF_DESTROY)
	e3:SetCondition(c89990007.descon)
	c:RegisterEffect(e3)
	--restrict spell
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e4:SetCode(EVENT_SPSUMMON_SUCCESS)
	e4:SetOperation(c89990007.actlimit)
	c:RegisterEffect(e4)
	--shuffling
	local e5=Effect.CreateEffect(c)
	e5:SetCategory(CATEGORY_TODECK+CATEGORY_SPECIAL_SUMMON)
	e5:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e5:SetType(EFFECT_TYPE_IGNITION)
	e5:SetCountLimit(1)
	e5:SetRange(LOCATION_MZONE)
	e5:SetTarget(c89990007.target)
	e5:SetOperation(c89990007.operation)
	c:RegisterEffect(e5)
end
function c89990007.spcon(e,c)
	if c==nil then return true end
	return Duel.GetLocationCount(c:GetControler(),LOCATION_MZONE)>-3
		and Duel.CheckReleaseGroup(c:GetControler(),Card.IsSetCard,3,nil,0x22b)
end
function c89990007.spop(e,tp,eg,ep,ev,re,r,rp,c)
	local g=Duel.SelectReleaseGroup(c:GetControler(),Card.IsSetCard,3,3,nil,0x22b)
	Duel.Release(g,REASON_COST)
end
function c89990007.desfilter(c)
	return c:IsFaceup() and c:IsCode(89990018)
end
function c89990007.descon(e)
	return not Duel.IsExistingMatchingCard(c89990007.desfilter,e:GetHandlerPlayer(),LOCATION_SZONE,0,1,nil)
end
function c89990007.actlimit(e,tp,eg,ep,ev,re,r,rp)
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_CANNOT_ACTIVATE)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetTargetRange(0,1)
	e1:SetValue(c89990007.elimit)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
end
function c89990007.elimit(e,te,tp)
	return te:IsHasType(EFFECT_TYPE_ACTIVATE)
end
function c89990007.filter(c)
	return c:IsSetCard(0x22b) and c:IsType(TYPE_MONSTER) and not c:IsType(TYPE_FUSION+TYPE_SYNCHRO+TYPE_XYZ) 
		and c:IsAbleToDeck()
end
function c89990007.filter2(c,e,tp)
	return c:IsSetCard(0x22b) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c89990007.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsControler(tp) and chkc:IsLocation(LOCATION_GRAVE) and chkc:IsType(TYPE_MONSTER) end
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0 
		and Duel.IsExistingTarget(c89990007.filter,tp,LOCATION_GRAVE,0,1,nil) 
	    and Duel.IsExistingMatchingCard(c89990007.filter2,tp,LOCATION_DECK,0,1,nil,e,tp) end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
    local g=Duel.SelectTarget(tp,c89990007.filter,tp,LOCATION_GRAVE,0,1,1,nil)
    Duel.SetOperationInfo(0,CATEGORY_TODECK,g,1,0,0)
    Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK)
end
function c89990007.operation(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc and tc:IsRelateToEffect(e) then
        Duel.SendtoDeck(g,nil,2,REASON_EFFECT)    
	end
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local sg=Duel.SelectMatchingCard(tp,c89990007.filter2,tp,LOCATION_DECK,0,1,1,nil,e,tp)
	if sg:GetCount()>0 then
		Duel.SpecialSummon(sg,0,tp,tp,false,false,POS_FACEUP)
	end
end
