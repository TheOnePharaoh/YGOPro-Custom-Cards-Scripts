--Following the Darkness 
function c11111113.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,11111113)
	e1:SetTarget(c11111113.target)
	e1:SetOperation(c11111113.activate)
	c:RegisterEffect(e1)
	--negate
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(11111113,0))
	e2:SetCategory(CATEGORY_NEGATE+CATEGORY_DESTROY)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_CHAINING)
	e2:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCondition(c11111113.negcon)
	e2:SetCost(c11111113.negcost)
	e2:SetTarget(c11111113.negtg)
	e2:SetOperation(c11111113.negop)
	c:RegisterEffect(e2)
end
function c11111113.filter(c,e,tp,lp)
	if bit.band(c:GetType(),0x81)~=0x81 or not c:IsSetCard(0x0dac401)
		or not c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_RITUAL,tp,true,false) then return false end
	return lp>c:GetLevel()*300
end
function c11111113.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		local lp=Duel.GetLP(tp)
		return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
			and Duel.IsExistingMatchingCard(c11111113.filter,tp,LOCATION_HAND+LOCATION_GRAVE+LOCATION_EXTRA,0,1,nil,e,tp,lp)
	end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND+LOCATION_GRAVE+LOCATION_EXTRA)
end
function c11111113.activate(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	local lp=Duel.GetLP(tp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local tg=Duel.SelectMatchingCard(tp,c11111113.filter,tp,LOCATION_HAND+LOCATION_GRAVE+LOCATION_EXTRA,0,1,1,nil,e,tp,lp)
	local tc=tg:GetFirst()
	if tc then
		Duel.PayLPCost(tp,tc:GetLevel()*300)
		tc:SetMaterial(Group.CreateGroup())
		Duel.SpecialSummon(tc,SUMMON_TYPE_RITUAL,tp,tp,true,false,POS_FACEUP)
		tc:CompleteProcedure()
	end
end
function c11111113.negfilter(c,tp)
	return c:IsFaceup() and c:IsSetCard(0x0dac401) and c:IsControler(tp) and c:IsLocation(LOCATION_MZONE)
end
function c11111113.negcon(e,tp,eg,ep,ev,re,r,rp)
	if not re:IsHasProperty(EFFECT_FLAG_CARD_TARGET) then return false end
	local g=Duel.GetChainInfo(ev,CHAININFO_TARGET_CARDS)
	return g and g:IsExists(c11111113.negfilter,1,nil,tp) and Duel.IsChainNegatable(ev)
end
function c11111113.negcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToRemoveAsCost() end
	Duel.Remove(e:GetHandler(),POS_FACEUP,REASON_COST)
end
function c11111113.negtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_NEGATE,eg,1,0,0)
	if re:GetHandler():IsDestructable() and re:GetHandler():IsRelateToEffect(re) then
		Duel.SetOperationInfo(0,CATEGORY_DESTROY,eg,1,0,0)
	end
end
function c11111113.negop(e,tp,eg,ep,ev,re,r,rp)
	Duel.NegateActivation(ev)
	if re:GetHandler():IsRelateToEffect(re) then
		Duel.Destroy(eg,REASON_EFFECT)
	end
end
