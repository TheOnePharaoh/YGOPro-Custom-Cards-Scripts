--Mechquipped Death Knight
function c19007855.initial_effect(c)
	--xyz summon
	aux.AddXyzProcedure(c,nil,3,2)
	c:EnableReviveLimit()
	--atk
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCode(EFFECT_UPDATE_ATTACK)
	e1:SetValue(c19007855.atkval)
	c:RegisterEffect(e1)
	--Disable
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e2:SetCode(EVENT_BATTLED)
	e2:SetCondition(c19007855.dscon)
	e2:SetOperation(c19007855.disop)
	c:RegisterEffect(e2)
	--destroy
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(19007855,0))
	e3:SetCategory(CATEGORY_DESTROY+CATEGORY_DAMAGE)
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetCountLimit(1)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCost(c19007855.cost)
	e3:SetTarget(c19007855.target)
	e3:SetOperation(c19007855.operation)
	c:RegisterEffect(e3)
	--special summon
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(19007855,1))
	e4:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e4:SetType(EFFECT_TYPE_QUICK_O)
	e4:SetCode(EVENT_FREE_CHAIN)
	e4:SetHintTiming(0,TIMING_END_PHASE)
	e4:SetRange(LOCATION_MZONE)
	e4:SetCondition(c19007855.spcon)
	e4:SetCost(c19007855.spcost)
	e4:SetTarget(c19007855.sptg)
	e4:SetOperation(c19007855.spop)
	c:RegisterEffect(e4)
end
function c19007855.atkfilter(c)
	return c:IsFaceup() and c:IsSetCard(0xda3791) or c:IsSetCard(0xda3790) or c:IsCode(15914410) or c:IsCode(41309158)
end
function c19007855.atkval(e,c)
	return Duel.GetMatchingGroupCount(c19007855.atkfilter,c:GetControler(),LOCATION_MZONE,0,nil)*200
end
function c19007855.dscon(e)
	return e:GetHandler():GetOverlayCount()~=0
end
function c19007855.disop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local bc=c:GetBattleTarget()
	if bc and bc:IsStatus(STATUS_BATTLE_DESTROYED) and bc:IsType(TYPE_FLIP) then
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_DISABLE)
		e1:SetReset(RESET_EVENT+0x17a0000)
		bc:RegisterEffect(e1)
		local e2=Effect.CreateEffect(c)
		e2:SetType(EFFECT_TYPE_SINGLE)
		e2:SetCode(EFFECT_DISABLE_EFFECT)
		e2:SetReset(RESET_EVENT+0x17a0000)
		bc:RegisterEffect(e2)
	end
end
function c19007855.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_COST) end
	e:GetHandler():RemoveOverlayCard(tp,1,1,REASON_COST)
end
function c19007855.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	if e:GetHandler():IsDefensePos() then
		Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,0,1-tp,500)
	end
end
function c19007855.operation(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then return end
	if Duel.Damage(1-tp,500,REASON_EFFECT)~=0 and Duel.IsExistingTarget(Card.IsDestructable,tp,0,LOCATION_ONFIELD,1,nil)then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
		local g=Duel.SelectTarget(tp,Card.IsDestructable,tp,0,LOCATION_ONFIELD,1,1,nil)
		Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,1,0,0)
		local tc=Duel.GetFirstTarget()
		if tc and tc:IsRelateToEffect(e) then
			Duel.Destroy(tc,REASON_EFFECT)
		end
	end
end
function c19007855.spcon(e)
	return e:GetHandler():GetOverlayCount()==0
end
function c19007855.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToExtraAsCost() end
	Duel.SendtoDeck(e:GetHandler(),nil,0,REASON_COST)
end
function c19007855.spfilter1(c,e,tp)
	return c:IsType(TYPE_MONSTER) and c:IsSetCard(0xda3791) or c:IsSetCard(0xda3790) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
		and Duel.IsExistingMatchingCard(c19007855.spfilter2,tp,LOCATION_DECK,0,1,nil,e,tp,c:GetCode())
end
function c19007855.spfilter2(c,e,tp,code)
	return c:IsType(TYPE_MONSTER) and c:IsSetCard(0xda3791) or c:IsSetCard(0xda3790) and not c:IsCode(code) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c19007855.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return not Duel.IsPlayerAffectedByEffect(tp,59822133)
		and Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c19007855.spfilter1,tp,LOCATION_DECK,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,2,tp,LOCATION_DECK)
end
function c19007855.spop(e,tp,eg,ep,ev,re,r,rp)
	if not Duel.IsPlayerAffectedByEffect(tp,59822133)
		and Duel.GetLocationCount(tp,LOCATION_MZONE)>1 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local g1=Duel.SelectMatchingCard(tp,c19007855.spfilter1,tp,LOCATION_DECK,0,1,1,nil,e,tp)
		if g1:GetCount()<=0 then return end
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local g2=Duel.SelectMatchingCard(tp,c19007855.spfilter2,tp,LOCATION_DECK,0,1,1,nil,e,tp,g1:GetFirst():GetCode())
		g1:Merge(g2)
		Duel.SpecialSummon(g1,0,tp,tp,false,false,POS_FACEUP_ATTACK)
	end
end