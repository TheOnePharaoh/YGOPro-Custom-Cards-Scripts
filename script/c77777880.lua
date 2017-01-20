--Maiden of the Glade
function c77777880.initial_effect(c)
	--To hand
	local e1=Effect.CreateEffect(c)
  e1:SetDescription(aux.Stringid(77777880,0))
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_FLIP+EFFECT_TYPE_TRIGGER_O)
	e1:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_DAMAGE_STEP)
  e1:SetCountLimit(1,77777880)
	e1:SetTarget(c77777880.thtg)
	e1:SetOperation(c77777880.thop)
	c:RegisterEffect(e1)
  --destroy
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(77777880,1))
	e2:SetCategory(CATEGORY_DESTROY)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e2:SetCode(EVENT_BATTLE_START)
	e2:SetCondition(c77777880.descon)
	e2:SetTarget(c77777880.destg)
	e2:SetOperation(c77777880.desop)
	c:RegisterEffect(e2)
  --attack limit
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e5:SetCode(EVENT_FLIP)
	e5:SetOperation(c77777880.flipop)
	c:RegisterEffect(e5)
end

function c77777880.flipop(e,tp,eg,ep,ev,re,r,rp)
	e:GetHandler():RegisterFlagEffect(77777876,RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END,0,1)
end
function c77777880.ssfilter(c,e,tp)
	return c:IsSetCard(0x40c) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c77777880.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToHand()end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,0,0)
end
function c77777880.thop(e,tp,eg,ep,ev,re,r,rp)
  if Duel.SendtoHand(e:GetHandler(),nil,REASON_EFFECT)~=0 
  and Duel.IsExistingMatchingCard(c77777880.ssfilter,tp,LOCATION_GRAVE,0,1,nil,e,tp) then
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
    local g=Duel.SelectMatchingCard(tp,c77777880.ssfilter,tp,LOCATION_GRAVE,0,1,2,nil,e,tp)
    if g:GetCount()>0 then
      Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEDOWN_DEFENSE)
    end
  end
end

function c77777880.descon(e,tp,eg,ep,ev,re,r,rp)
	local d=Duel.GetAttackTarget()
	return e:GetHandler()==Duel.GetAttacker() and d and d:IsFacedown() and d:IsDefensePos()
end
function c77777880.destg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,Duel.GetAttackTarget(),1,0,0)
end
function c77777880.desop(e,tp,eg,ep,ev,re,r,rp)
	local d=Duel.GetAttackTarget()
	if d:IsRelateToBattle() then
		Duel.Destroy(d,REASON_EFFECT)
	end
end