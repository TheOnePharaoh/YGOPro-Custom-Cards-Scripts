--Grand Guardian Draco
function c103950008.initial_effect(c)

	--XYZ Summon
	aux.AddXyzProcedure(c,nil,6,2)
	c:EnableReviveLimit()
	
	--Special Summon
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(103950008,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetRange(LOCATION_EXTRA)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCondition(c103950008.spcon)
	e1:SetTarget(c103950008.sptgt)
	e1:SetOperation(c103950008.spop)
	c:RegisterEffect(e1)
	
	--Destruction Replace
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(103950008,1))
	e2:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_DESTROY_REPLACE)
	e2:SetRange(LOCATION_MZONE)
	e2:SetTarget(c103950008.destg)
	e2:SetValue(c103950008.desval)
	e2:SetOperation(c103950008.desop)
	c:RegisterEffect(e2)
end

--Special Summon condition
function c103950008.spcon(e,tp,eg,ep,ev,re,r,rp)
	return (Duel.GetCurrentPhase()==PHASE_MAIN1 or Duel.GetCurrentPhase()==PHASE_MAIN2) and
			Duel.GetFlagEffect(tp,103950008)==0
end

--Special Summon material filter
function c103950008.spmatfilter(c)
	return c:GetLevel()==6 and c:IsRace(RACE_DRAGON) and (not c:IsLocation(LOCATION_MZONE) or c:IsFaceup()) and not c:IsHasEffect(EFFECT_CANNOT_BE_XYZ_MATERIAL)
end

--Special Summon target
function c103950008.sptgt(e,tp,eg,ep,ev,re,r,rp,chk,chkc)

	if chkc then return chkc:IsControler(tp) and
						(chkc:IsLocation(LOCATION_MZONE) or chkc:IsLocation(LOCATION_HAND)) and
						c103950008.spmatfilter(chkc) end
	
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>-1 and
							Duel.IsExistingTarget(c103950008.spmatfilter,tp,LOCATION_MZONE+LOCATION_HAND,0,2,nil) end
	
	Duel.RegisterFlagEffect(tp,103950008,RESET_PHASE+PHASE_END,0,1)
	
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	local g=Duel.SelectTarget(tp,c103950008.spmatfilter,tp,LOCATION_MZONE+LOCATION_HAND,0,2,2,nil)
	
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end

--Special Summon operation
function c103950008.spop(e,tp,eg,ep,ev,re,r,rp)
	local c = e:GetHandler()

	if not c:IsRelateToEffect(e) then return end

	local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS)
	local sg=g:Filter(Card.IsRelateToEffect,nil,e):Filter(c103950008.spmatfilter,nil):Filter(Card.IsControler,nil,tp)
	if sg:GetCount() < 2 then return end
	
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 and sg:Filter(Card.IsLocation,nil,LOCATION_MZONE):GetCount() <= 0 then return end
	
	Duel.Overlay(c,sg)
	Duel.SpecialSummon(c,SUMMON_TYPE_XYZ,tp,tp,false,false,POS_FACEUP)
	c:CompleteProcedure()
end

--Destruction Replace target
function c103950008.destg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return eg:IsExists(Card.IsReason,1,nil,REASON_BATTLE)
		and e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_EFFECT) end
		
	local opt = Duel.SelectYesNo(tp,aux.Stringid(103950008,2))
	if opt then e:SetLabelObject(eg:GetFirst()) end
	
	return opt
end

--Destruction Replace value
function c103950008.desval(e,c)
	return c:IsReason(REASON_BATTLE)
end

--Destruction Replace operation
function c103950008.desop(e,tp,eg,ep,ev,re,r,rp)
	local c = e:GetHandler()
	local b = e:GetLabelObject()
	c:RemoveOverlayCard(tp,1,1,REASON_EFFECT)
	
	local a=Duel.GetAttacker()
	if not a or not a:IsRelateToBattle() or (a == b) then
		a=Duel.GetAttackTarget()
		if not a or not a:IsRelateToBattle() or (a == b) then return end
	end
	
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_UPDATE_ATTACK)
	e1:SetValue(-1000)
	e1:SetReset(RESET_EVENT+0x1fe0000)
	a:RegisterEffect(e1)
end