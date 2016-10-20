--Moonshadow Dragon
function c103950019.initial_effect(c)
	
	--Tribute Summon
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(103950019,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetHintTiming(0,TIMING_STANDBY_PHASE+0x1c0)
	e1:SetRange(LOCATION_HAND)
	e1:SetCondition(c103950019.spcon)
	e1:SetCost(c103950019.spcost)
	e1:SetOperation(c103950019.spop)
	e1:SetCountLimit(1)
	c:RegisterEffect(e1)
	
	--Banished
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e3:SetCode(EVENT_REMOVE)
	e3:SetOperation(c103950019.rmop)
	c:RegisterEffect(e3)
	
	--Banished resolve
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(103950019,1))
	e4:SetCategory(CATEGORY_REMOVE)
	e4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e4:SetCode(EVENT_PHASE+PHASE_END)
	e4:SetRange(LOCATION_REMOVED)
	e4:SetCondition(c103950019.rmcon)
	e4:SetTarget(c103950019.target3)
	e4:SetOperation(c103950019.rmres)
	e4:SetCountLimit(1)
	c:RegisterEffect(e4)
end

--Special Summon condition
function c103950019.spcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) and
		Duel.GetFlagEffect(tp,103950019)==0
end
--Special Summon cost filter
function c103950019.filter1(c)
	return c:GetLevel()>=4 and c:IsAbleToGraveAsCost()
end
--Special Summon cost
function c103950019.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c103950019.filter1,tp,LOCATION_MZONE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectMatchingCard(tp,c103950019.filter1,tp,LOCATION_MZONE,0,1,1,nil)
	Duel.SendtoGrave(g,REASON_COST)
	Duel.RegisterFlagEffect(tp,103950019,RESET_PHASE+PHASE_END,0,1)
end

--Special Summon operation
function c103950019.spop(e,tp,eg,ep,ev,re,r,rp)
	local c = e:GetHandler()
	if c:IsRelateToEffect(e) then
		Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)
		
		local atk=c:GetBaseAttack()
		local def=c:GetBaseDefense()
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
		e1:SetRange(LOCATION_MZONE)
		e1:SetReset(RESET_EVENT+0xff0000)
		e1:SetCode(EFFECT_SET_BASE_ATTACK)
		e1:SetValue(def)
		c:RegisterEffect(e1)
		
		local e2=Effect.CreateEffect(c)
		e2:SetType(EFFECT_TYPE_SINGLE)
		e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
		e2:SetRange(LOCATION_MZONE)
		e2:SetReset(RESET_EVENT+0xff0000)
		e2:SetCode(EFFECT_SET_BASE_DEFENSE)
		e2:SetValue(atk)
		c:RegisterEffect(e2)
	end
end

--Is Banished operation
function c103950019.rmop(e,tp,eg,ep,ev,re,r,rp)
	if e:GetHandler():IsFacedown() then return end
	e:GetHandler():RegisterFlagEffect(103950019,RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END,0,1)
end
--Is Banished condition
function c103950019.rmcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetFlagEffect(103950019)~=0
end
--Banish card filter
function c103950019.filter3(c)
	return c:IsFaceup() and c:IsType(TYPE_MONSTER) and c:IsAbleToRemove()
end
--Banish card target
function c103950019.target3(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_GRAVE) and c103950019.filter3(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c103950019.filter3,tp,LOCATION_GRAVE,0,1,nil) and
						Duel.IsExistingTarget(c103950019.filter3,tp,0,LOCATION_GRAVE,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g1=Duel.SelectTarget(tp,c103950019.filter3,tp,LOCATION_GRAVE,0,1,1,nil)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g2=Duel.SelectTarget(tp,c103950019.filter3,tp,0,LOCATION_GRAVE,1,1,nil)
	g1:Merge(g2)
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,g1,1,0,0)
end
--Banish card resolve
function c103950019.rmres(e,tp,eg,ep,ev,re,r,rp,chk)
	local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS)
	local tg=g:Filter(Card.IsRelateToEffect,nil,e)
	if tg:GetCount()>0 then
		Duel.Remove(tg,POS_FACEUP,REASON_EFFECT)
	end
end