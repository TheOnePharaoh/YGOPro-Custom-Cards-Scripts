--No.39 希望皇ビヨンド・ザ・ホープ
function c512000012.initial_effect(c)
	--xyz summon
	aux.AddXyzProcedure(c,nil,6,2)
	c:EnableReviveLimit()
	--Immune
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_IMMUNE_EFFECT)
	e1:SetProperty(EFFECT_FLAG_SET_AVAILABLE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetTargetRange(LOCATION_ONFIELD,0)
	e1:SetCondition(c512000012.econ)
	e1:SetValue(c512000012.efilter)
	c:RegisterEffect(e1)
	--atk down
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_SET_ATTACK_FINAL)
	e2:SetRange(LOCATION_MZONE)
	e2:SetTargetRange(0,LOCATION_MZONE)
	e2:SetCondition(c512000012.atkcon)
	e2:SetValue(0)
	c:RegisterEffect(e2)
	--detach
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e3:SetCode(EVENT_PHASE+PHASE_BATTLE)
	e3:SetCountLimit(1)
	e3:SetRange(LOCATION_MZONE)
	e3:SetLabel(1)
	e3:SetCondition(c512000012.detcon)
	e3:SetOperation(c512000012.detop)
	c:RegisterEffect(e3)
	--atk check
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e4:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e4:SetCode(EVENT_ATTACK_ANNOUNCE)
	e4:SetRange(LOCATION_MZONE)
	e4:SetCondition(c512000012.regcon)
	e4:SetOperation(c512000012.regop)
	e4:SetLabelObject(e3)
	c:RegisterEffect(e4)
	--reset
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e5:SetCode(EVENT_PHASE+PHASE_END)
	e5:SetRange(LOCATION_MZONE)
	e5:SetCountLimit(1)
	e5:SetCondition(c512000012.rescon)
	e5:SetOperation(c512000012.resop)
	e5:SetLabelObject(e3)
	c:RegisterEffect(e5)
	--spsummon
	local e6=Effect.CreateEffect(c)
	e6:SetDescription(aux.Stringid(21521304,1))
	e6:SetCategory(CATEGORY_REMOVE+CATEGORY_SPECIAL_SUMMON+CATEGORY_RECOVER)
	e6:SetType(EFFECT_TYPE_QUICK_O)
	e6:SetCode(EVENT_FREE_CHAIN)
	e6:SetRange(LOCATION_MZONE)
	e6:SetCountLimit(1)
	e6:SetCondition(c512000012.spcon)
	e6:SetCost(c512000012.spcost)
	e6:SetTarget(c512000012.sptg)
	e6:SetOperation(c512000012.spop)
	c:RegisterEffect(e6)
	if not c512000012.global_check then
		c512000012.global_check=true
		local ge2=Effect.CreateEffect(c)
		ge2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge2:SetCode(EVENT_ADJUST)
		ge2:SetCountLimit(1)
		ge2:SetProperty(EFFECT_FLAG_NO_TURN_RESET)
		ge2:SetOperation(c512000012.numchk)
		Duel.RegisterEffect(ge2,0)
	end
end
c512000012.xyz_number=39
function c512000012.efilter(e,re)
	return e:GetHandlerPlayer()~=re:GetHandlerPlayer()
end
function c512000012.econ(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetOverlayCount()>0
end
function c512000012.atkcon(e)
	local ph=Duel.GetCurrentPhase()
	return Duel.GetTurnPlayer()==e:GetHandlerPlayer() and ph>=0x08 and ph<=0x80 
		and e:GetHandler():GetOverlayGroup():IsExists(Card.IsCode,1,nil,84013237)
end
function c512000012.regcon(e,tp,eg,ep,ev,re,r,rp)
	return tp==Duel.GetTurnPlayer() and e:GetHandler():GetOverlayGroup():IsExists(Card.IsCode,1,nil,84013237)
end
function c512000012.regop(e,tp,eg,ep,ev,re,r,rp)
	local atk=e:GetLabelObject():GetLabel()
	if atk>0 then
		e:GetLabelObject():SetLabel(0)
	end
end
function c512000012.detcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetLabel()==0 and e:GetHandler():GetOverlayGroup():IsExists(Card.IsCode,1,nil,84013237)
end
function c512000012.detop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:GetOverlayCount()>0 then
		c:RemoveOverlayCard(tp,1,1,REASON_EFFECT)
	end
end
function c512000012.rescon(e)
	return e:GetLabelObject():GetLabel()==0
end
function c512000012.resop(e,tp,eg,ep,ev,re,r,rp)
	e:GetLabelObject():SetLabel(1)
end
function c512000012.spcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetCurrentPhase()>=PHASE_BATTLE_START and Duel.GetCurrentPhase()<=PHASE_BATTLE 
		and e:GetHandler():GetOverlayGroup():IsExists(Card.IsCode,1,nil,84013237)
end
function c512000012.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_COST) end
	e:GetHandler():RemoveOverlayCard(tp,1,1,REASON_COST)
end
function c512000012.rmfilter(c)
	return c:IsFaceup() and c:IsType(TYPE_XYZ) and c:IsAbleToRemove()
end
function c512000012.spfilter(c,e,tp)
	return c:IsCode(84013237) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c512000012.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>-1
		and Duel.IsExistingMatchingCard(c512000012.rmfilter,tp,LOCATION_MZONE,0,1,nil)
		and Duel.IsExistingMatchingCard(c512000012.spfilter,tp,LOCATION_GRAVE,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,nil,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_RECOVER,0,0,tp,1250)
end
function c512000012.spop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g1=Duel.SelectMatchingCard(tp,c512000012.rmfilter,tp,LOCATION_MZONE,0,1,1,nil)
	if g1:GetCount()>0 then
		Duel.HintSelection(g1)
		if Duel.Remove(g1,POS_FACEUP,REASON_EFFECT)==0 then return end
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local g2=Duel.SelectMatchingCard(tp,c512000012.spfilter,tp,LOCATION_GRAVE,0,1,1,nil,e,tp)
		Duel.HintSelection(g2)
		if Duel.SpecialSummon(g2,0,tp,tp,false,false,POS_FACEUP)==0 then return end
		Duel.BreakEffect()
		Duel.Recover(tp,g2:GetFirst():GetAttack()/2,REASON_EFFECT)
	end
end
function c512000012.numchk(e,tp,eg,ep,ev,re,r,rp)
	Duel.CreateToken(tp,21521304)
	Duel.CreateToken(1-tp,21521304)
end
