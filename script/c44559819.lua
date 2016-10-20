--Tai Shan Wang, Descendant of the Nirvana
function c44559819.initial_effect(c)
	c:SetUniqueOnField(1,0,44559819)
	--special summon
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e1:SetRange(LOCATION_HAND)
	e1:SetCondition(c44559819.spcon)
	c:RegisterEffect(e1)
	--damage
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_DAMAGE)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_SUMMON_SUCCESS)
	e2:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
	e2:SetOperation(c44559819.damop)
	c:RegisterEffect(e2)
	local e3=e2:Clone()
	e3:SetCode(EVENT_FLIP_SUMMON_SUCCESS)
	c:RegisterEffect(e3)
	local e4=e2:Clone()
	e4:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e4)
	--search
	local e5=Effect.CreateEffect(c)
	e5:SetDescription(aux.Stringid(44559819,0))
	e5:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e5:SetType(EFFECT_TYPE_IGNITION)
	e5:SetRange(LOCATION_HAND)
	e5:SetCountLimit(1,44559819)
	e5:SetCost(c44559819.cost)
	e5:SetTarget(c44559819.target)
	e5:SetOperation(c44559819.operation)
	c:RegisterEffect(e5)
end
function c44559819.spfilter(c)
	return c:IsFaceup() and c:IsSetCard(0x2017) and c:IsType(TYPE_FUSION)
end
function c44559819.spcon(e,c)
	if c==nil then return true end
	return Duel.GetLocationCount(c:GetControler(),LOCATION_MZONE)>0 and
		Duel.IsExistingMatchingCard(c44559819.spfilter,c:GetControler(),LOCATION_MZONE,0,2,nil)
end
function c44559819.damop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Damage(1-tp,1200,REASON_EFFECT)
end
function c44559819.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return c:IsAbleToGraveAsCost() and c:IsDiscardable() end
	Duel.SendtoGrave(c,REASON_COST+REASON_DISCARD)
end
function c44559819.thfilter(c)
	return c:GetCode()==24094653 and c:IsAbleToHand()
end
function c44559819.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chk==0 then return Duel.IsExistingMatchingCard(c44559819.thfilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c44559819.operation(e,tp,eg,ep,ev,re,r,rp,chk)
	local tg=Duel.GetFirstMatchingCard(c44559819.thfilter,tp,LOCATION_DECK,0,nil)
	if tg then
		Duel.SendtoHand(tg,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,tg)
	end
end