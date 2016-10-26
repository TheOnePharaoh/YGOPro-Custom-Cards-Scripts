--Mystic Fauna Deergle
function c77777855.initial_effect(c) 
  --xyz summon
	aux.AddXyzProcedure(c,aux.FilterBoolFunction(Card.IsSetCard,0x40a),2,2)
	c:EnableReviveLimit()
  --direct attack
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(77777855,0))
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCost(c77777855.cost)
  e1:SetTarget(c77777855.target)
	e1:SetOperation(c77777855.operation)
	c:RegisterEffect(e1)
  --search
	local e2=Effect.CreateEffect(c)
  e2:SetDescription(aux.Stringid(77777855,1))
	e2:SetCategory(CATEGORY_SEARCH+CATEGORY_TOHAND)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	e2:SetCondition(c77777855.con)
	e2:SetTarget(c77777855.tg)
	e2:SetOperation(c77777855.op)
	c:RegisterEffect(e2)
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetCode(EFFECT_MATERIAL_CHECK)
	e3:SetValue(c77777855.valcheck)
	e3:SetLabelObject(e2)
	c:RegisterEffect(e3)
end

function c77777855.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_COST) end
	e:GetHandler():RemoveOverlayCard(tp,1,1,REASON_COST)
end
function c77777855.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetFlagEffect(tp,77777855)==0 end
end
function c77777855.operation(e,tp,eg,ep,ev,re,r,rp)
  --Cannot attack/can attack directly
  local e4=Effect.CreateEffect(e:GetHandler())
  e4:SetType(EFFECT_TYPE_FIELD)
  e4:SetCode(EFFECT_DIRECT_ATTACK)
  e4:SetProperty(EFFECT_FLAG_OATH)
  e4:SetRange(LOCATION_MZONE)
  e4:SetTargetRange(LOCATION_MZONE,0)
  e4:SetReset(RESET_PHASE+PHASE_END+RESET_OPPO_TURN)
  e4:SetLabel(e:GetHandler():GetFieldID())
	e4:SetTarget(aux.TargetBoolFunction(Card.IsSetCard,0x40a))
  Duel.RegisterEffect(e4,tp)
  local e5=Effect.CreateEffect(e:GetHandler())
  e5:SetType(EFFECT_TYPE_FIELD)
  e5:SetCode(EFFECT_CANNOT_ATTACK)
  e5:SetRange(LOCATION_MZONE)
  e5:SetProperty(EFFECT_FLAG_OATH)
  e5:SetLabel(e:GetHandler():GetFieldID())
  e5:SetTargetRange(0,LOCATION_MZONE)
  e5:SetReset(RESET_PHASE+PHASE_END+RESET_OPPO_TURN)
  Duel.RegisterEffect(e5,tp)
  Duel.RegisterFlagEffect(tp,77777855,RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END,0,1)
end
--[[function c77777855.condition(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetFlagEffect(tp,77777855)~=0
end]]--



function c77777855.con(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetSummonType()==SUMMON_TYPE_XYZ and e:GetLabel()==1
end
function c77777855.filter2(c)
	return c:IsSetCard(0x40a) and c:IsAbleToHand() and c:IsType(TYPE_SPELL+TYPE_TRAP)
end
function c77777855.filter(c)
	return c:IsSetCard(0x40a) and c:IsFaceup()
end
function c77777855.tg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c77777855.filter2,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c77777855.op(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c77777855.filter2,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		if Duel.SendtoHand(g,nil,REASON_EFFECT)~=0 then
      Duel.ConfirmCards(1-tp,g)
      --Immune to effect
      --I realize how horribly formatted this effect is, but idgaf.
      local e3=Effect.CreateEffect(e:GetHandler())
      e3:SetType(EFFECT_TYPE_FIELD)
      e3:SetCode(EFFECT_IMMUNE_EFFECT)
      e3:SetProperty(EFFECT_FLAG_OATH)
      e3:SetRange(LOCATION_MZONE)
      e3:SetValue(c77777855.efilter)
      e3:SetTargetRange(LOCATION_MZONE,0)
      e3:SetOwnerPlayer(tp)
      e3:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
      e3:SetLabel(e:GetHandler():GetFieldID())
      e3:SetTarget(aux.TargetBoolFunction(Card.IsSetCard,0x40a))
      Duel.RegisterEffect(e3,tp)
    end
	end
end
function c77777855.efilter(e,re)
	return e:GetOwnerPlayer()~=re:GetOwnerPlayer()
end
function c77777855.valcheck(e,c)
	local g=c:GetMaterial()
	if g:IsExists(Card.IsType,1,nil,TYPE_SYNCHRO) then
		e:GetLabelObject():SetLabel(1)
	else
		e:GetLabelObject():SetLabel(0)
	end
end