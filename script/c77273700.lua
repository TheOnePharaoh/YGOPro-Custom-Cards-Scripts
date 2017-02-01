--Stardust Light Dragon
function c77273700.initial_effect(c)
   aux.AddSynchroProcedure(c,nil,aux.NonTuner(nil),1)
	c:EnableReviveLimit()
local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(34778416,0))
	e3:SetCategory(CATEGORY_NEGATE+CATEGORY_DESTROY)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_QUICK_O)
	e3:SetCode(EVENT_CHAINING)
	e3:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCountLimit(1)
	e3:SetCondition(c77273700.negcon)
	e3:SetCost(c77273700.cost)
	e3:SetOperation(c77273700.disop)
	c:RegisterEffect(e3)
 local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(44508094,1))
	e2:SetType(EFFECT_TYPE_TRIGGER_O+EFFECT_TYPE_FIELD)
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetCode(EVENT_PHASE+PHASE_END)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCountLimit(1)
	e2:SetTarget(c77273700.sumtg)
	e2:SetOperation(c77273700.sumop)
	c:RegisterEffect(e2)
end
function c77273700.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsReleasable() end
	Duel.Release(e:GetHandler(),REASON_COST)
end
function c77273700.negcon(e,tp,eg,ep,ev,re,r,rp)
	return ep~=tp
end
function c77273700.disop(e,tp,eg,ep,ev,re,r,rp)
	if ep==tp then return end
	local rc=re:GetHandler()
	Duel.SetChainLimit(c77273700.chlimit)
	Duel.NegateEffect(ev)
	if rc:IsRelateToEffect(re) then
		Duel.SendtoGrave(rc,REASON_EFFECT)
	end
 e:GetHandler():RegisterFlagEffect(77273700,RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END,0,0)
end
function c77273700.chlimit(e,ep,tp)
	return tp==ep
end
function c77273700.sumtg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and c:GetFlagEffect(77273700)>0
		and c:IsCanBeSpecialSummoned(e,0,tp,false,false) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,c,1,0,0)
	Duel.SetChainLimit(c77273700.chlimit)
end
function c77273700.sumop(e,tp,eg,ep,ev,re,r,rp)
	if e:GetHandler():IsRelateToEffect(e) then
		Duel.SpecialSummon(e:GetHandler(),0,tp,tp,false,false,POS_FACEUP)
	end
end