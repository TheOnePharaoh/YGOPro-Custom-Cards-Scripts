--Mystic Fauna Hippogrif
function c77777857.initial_effect(c)
  --xyz summon
	aux.AddXyzProcedure(c,aux.FilterBoolFunction(Card.IsSetCard,0x40a),2,2)
	c:EnableReviveLimit()
  --can't negate summon
  local e1=Effect.CreateEffect(c)
  e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_CANNOT_DISABLE_SPSUMMON)
	e1:SetRange(LOCATION_MZONE)
	e1:SetProperty(EFFECT_FLAG_IGNORE_RANGE+EFFECT_FLAG_SET_AVAILABLE)
	e1:SetTarget(aux.TargetBoolFunction(Card.IsLevelBelow,2))
  c:RegisterEffect(e1)
  --Negate Summon
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_DISABLE_SUMMON+CATEGORY_DESTROY)
	e2:SetDescription(aux.Stringid(77777857,0))
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCode(EVENT_SPSUMMON)
	e2:SetCountLimit(2,77777857)
	e2:SetCondition(c77777857.discon)
	e2:SetTarget(c77777857.distg)
	e2:SetOperation(c77777857.disop)
	c:RegisterEffect(e2)
  --double atk
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_IGNITION)
	e4:SetCode(EVENT_FREE_CHAIN)
	e4:SetDescription(aux.Stringid(77777857,1))
	e4:SetRange(LOCATION_MZONE)
  e4:SetCost(c77777857.cost)
	e4:SetTarget(c77777857.target)
	e4:SetOperation(c77777857.operation)
	c:RegisterEffect(e4)
end

function c77777857.discon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetCurrentChain()==0
end
function c77777857.distg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return eg:GetCount()==1 and (eg:GetFirst():IsLevelAbove(3)or eg:GetFirst():IsRankAbove(3)) end
	Duel.SetOperationInfo(0,CATEGORY_DISABLE_SUMMON,eg,eg:GetCount(),0,0)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,eg,eg:GetCount(),0,0)
end
function c77777857.disop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsFacedown() or not c:IsRelateToEffect(e) then return end
	Duel.NegateSummon(eg)
	Duel.Destroy(eg,REASON_EFFECT)
end

function c77777857.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_COST) end
	e:GetHandler():RemoveOverlayCard(tp,1,1,REASON_COST)
end
function c77777857.doublefilter(e,c)
	return c:IsSetCard(0x40a)and c:IsType(TYPE_XYZ+TYPE_SYNCHRO)and c:IsFaceup()
end
function c77777857.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetFlagEffect(tp,77777857)==0 end
end
function c77777857.operation(e,tp,eg,ep,ev,re,r,rp)
	local e5=Effect.CreateEffect(e:GetHandler())
  e5:SetType(EFFECT_TYPE_FIELD)
  e5:SetCode(EFFECT_EXTRA_ATTACK)
  e5:SetValue(1)
  e5:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
  e5:SetProperty(EFFECT_FLAG_OATH)
  e5:SetLabel(e:GetHandler():GetFieldID())
  e5:SetTargetRange(LOCATION_MZONE,0)
  e5:SetTarget(c77777857.doublefilter)
  Duel.RegisterEffect(e5,tp)
  Duel.RegisterFlagEffect(tp,77777857,RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END,0,1)
end