--Vocaloid Miki
function c89200699.initial_effect(c)
	--spsummon
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetRange(LOCATION_HAND)
	e1:SetCode(EVENT_DESTROYED)
	e1:SetCondition(c89200699.spcon)
	e1:SetTarget(c89200699.sptg)
	e1:SetOperation(c89200699.spop)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetRange(LOCATION_HAND)
	e2:SetCode(EVENT_BATTLE_DESTROYED)
	e2:SetCondition(c89200699.spcon)
	e2:SetTarget(c89200699.sptg)
	e2:SetOperation(c89200699.spop)
	c:RegisterEffect(e2)
	--nontuner
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCode(EFFECT_NONTUNER)
	c:RegisterEffect(e3)	
end
function c89200699.cfilter(c,tp)
	return c:IsPreviousLocation(LOCATION_MZONE) and c:IsLocation(LOCATION_GRAVE)
	 and c:IsPreviousPosition(POS_FACEUP) and c:GetPreviousControler()~=tp
end
function c89200699.spcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c89200699.cfilter,1,nil,tp)
end
function c89200699.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsRelateToEffect(e)
		and Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function c89200699.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then
		Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)
	end
end