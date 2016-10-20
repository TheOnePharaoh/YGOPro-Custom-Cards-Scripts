--Chosen Undead
--lua script by SGJin
function c12310716.initial_effect(c)
	--pendulum summon
	aux.EnablePendulumAttribute(c)
	--to hand
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(12310716,1))
	e3:SetCategory(CATEGORY_TOHAND)
	e3:SetProperty(EFFECT_FLAG_NO_TURN_RESET)
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetRange(LOCATION_PZONE)
	e3:SetCountLimit(1)
	e3:SetTarget(c12310716.thtg)
	e3:SetOperation(c12310716.thop)
	c:RegisterEffect(e3)
	--Special Summon (respawn)
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(12310716,0))
	e4:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e4:SetProperty(EFFECT_FLAG_CHAIN_UNIQUE)
	e4:SetCode(EVENT_TO_GRAVE)
	e4:SetCondition(c12310716.condtion)
	e4:SetTarget(c12310716.target)
	e4:SetOperation(c12310716.operation)
	c:RegisterEffect(e4)
end
function c12310716.condtion(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsPreviousLocation(LOCATION_DECK+LOCATION_HAND) and bit.band(r,REASON_EFFECT)==REASON_EFFECT
end
function c12310716.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetFlagEffect(tp,12310716)==0 end
	local opt=0
	local c=e:GetHandler()
	local b1=Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
	local b2=c:IsAbleToHand()
	if b1 and b2 then
		opt=Duel.SelectOption(tp,aux.Stringid(12310716,1),aux.Stringid(12310716,2))
	elseif b1 then
		opt=Duel.SelectOption(tp,aux.Stringid(12310716,1))
	elseif b2 then
		opt=Duel.SelectOption(tp,aux.Stringid(12310716,2))+1
	end
	e:SetLabel(opt)
	if opt==0 then
		e:SetCategory(CATEGORY_SPECIAL_SUMMON)
		Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
	elseif opt==1 then
		e:SetCategory(CATEGORY_TOHAND)
		Duel.SetOperationInfo(0,CATEGORY_TOHAND,e:GetHandler(),1,0,0)
	else
		e:SetCategory(0)
	end
	Duel.RegisterFlagEffect(tp,12310716,RESET_PHASE+PHASE_END,0,1)
end
function c12310716.operation(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then return end
	if e:GetLabel()==0 then
		Duel.SpecialSummon(e:GetHandler(),0,tp,tp,false,false,POS_FACEUP)
	elseif e:GetLabel()==1 then
		Duel.SendtoHand(c,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,c)
	end
end
function c12310716.tgfilter(c)
	return c:IsType(TYPE_NORMAL) and c:IsAbleToHand()
end
function c12310716.thtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_GRAVE) and chkc:IsControler(tp) and c12310716.tgfilter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c12310716.tgfilter,tp,LOCATION_GRAVE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local sg=Duel.SelectTarget(tp,c12310716.tgfilter,tp,LOCATION_GRAVE,0,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,sg,sg:GetCount(),0,0)
end
function c12310716.thop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc and tc:IsRelateToEffect(e) then
		Duel.SendtoHand(tc,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,tc)
	end
end
